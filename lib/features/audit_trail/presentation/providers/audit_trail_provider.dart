import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/audit_remote_datasource.dart';
import '../../data/repositories/audit_repository_impl.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/entities/audit_query.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/usecases/list_audit_logs.dart';

final auditRemoteDatasourceProvider = Provider<AuditRemoteDatasource>((ref) {
  return AuditRemoteDatasource(ref.read(apiClientProvider));
});

final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  return AuditRepositoryImpl(remoteDatasource: ref.read(auditRemoteDatasourceProvider));
});

final listAuditLogsUseCaseProvider = Provider<ListAuditLogs>((ref) {
  return ListAuditLogs(ref.watch(auditRepositoryProvider));
});

class AuditLogsState {
  const AuditLogsState({
    this.logs = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
  });

  final List<AuditLog> logs;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;

  AuditLogsState copyWith({
    List<AuditLog>? logs,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
  }) {
    return AuditLogsState(
      logs: logs ?? this.logs,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final auditLogsControllerProvider =
    StateNotifierProvider<AuditLogsController, AuditLogsState>((ref) {
  return AuditLogsController(ListAuditLogs(ref.watch(auditRepositoryProvider)));
});

class AuditLogsController extends StateNotifier<AuditLogsState> {
  AuditLogsController(this._listAuditLogs) : super(const AuditLogsState());

  final ListAuditLogs _listAuditLogs;

  Future<void> loadFirstPage({AuditQuery? query}) async {
    final effectiveQuery = query ?? const AuditQuery();
    state = state.copyWith(isLoading: true);
    try {
      final logs = await _listAuditLogs(query: effectiveQuery);
      state = AuditLogsState(
        logs: logs,
        page: 1,
        hasMore: logs.length == effectiveQuery.limit,
        isLoading: false,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> loadNextPage(AuditQuery query) async {
    if (state.isLoadingMore || !state.hasMore) return;
    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true);
    try {
      final newLogs = await _listAuditLogs(query: query.copyWith(page: nextPage));
      state = state.copyWith(
        logs: [...state.logs, ...newLogs],
        page: nextPage,
        hasMore: newLogs.length == query.limit,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
      rethrow;
    }
  }

  Future<void> refresh() async {
    final query = const AuditQuery();
    await loadFirstPage(query: query);
  }
}

final auditTrailFiltersProvider =
    StateProvider<AuditQuery>((ref) => const AuditQuery());

final auditTrailControllerProvider =
    StateNotifierProvider<AuditTrailController, AuditTrailState>((ref) {
  return AuditTrailController(ListAuditLogs(ref.watch(auditRepositoryProvider)));
});

class AuditTrailState extends AuditLogsState {
  const AuditTrailState({
    super.logs = const [],
    super.page = 1,
    super.hasMore = true,
    super.isLoading = false,
    super.isLoadingMore = false,
    required this.query,
  });

  final AuditQuery query;

  AuditTrailState copyWith({
    List<AuditLog>? logs,
    AuditQuery? query,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
  }) {
    return AuditTrailState(
      logs: logs ?? this.logs,
      query: query ?? this.query,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class AuditTrailController extends StateNotifier<AuditTrailState> {
  AuditTrailController(this._listAuditLogs) : super(const AuditTrailState(query: AuditQuery()));

  final ListAuditLogs _listAuditLogs;

  Future<void> applyFilters(AuditQuery query) async {
    state = AuditTrailState(
      logs: [],
      query: query,
      page: 1,
      hasMore: true,
      isLoading: true,
      isLoadingMore: false,
    );
    try {
      final logs = await _listAuditLogs(query: query.copyWith(page: 1));
      state = AuditTrailState(
        logs: logs,
        query: query,
        page: 1,
        hasMore: logs.length == query.limit,
        isLoading: false,
        isLoadingMore: false,
      );
    } catch (e) {
      state = AuditTrailState(
        logs: const [],
        query: query,
        page: 1,
        hasMore: true,
        isLoading: false,
        isLoadingMore: false,
      );
      rethrow;
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;
    final nextPage = state.page + 1;
    final nextQuery = state.query.copyWith(page: nextPage);
    state = state.copyWith(isLoadingMore: true);
    try {
      final newLogs = await _listAuditLogs(query: nextQuery);
      state = state.copyWith(
        logs: [...state.logs, ...newLogs],
        page: nextPage,
        hasMore: newLogs.length == state.query.limit,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
      rethrow;
    }
  }

  Future<void> resetToGeneral() async {
    final query = const AuditQuery();
    await applyFilters(query);
  }
}
