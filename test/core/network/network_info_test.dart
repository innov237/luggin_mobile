import 'package:luggin/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionCkecker extends Mock implements DataConnectionChecker {
  void main() {
    NetworkInfoImpl networkInfoImpl;
    MockDataConnectionCkecker mockDataConnectionCkecker;

    setUp(() {
      mockDataConnectionCkecker = MockDataConnectionCkecker();
      networkInfoImpl = NetworkInfoImpl(mockDataConnectionCkecker);
    });

    group('isConnected', () {
      test('should forward the call to DataConnectionChecker.hasConnection',
          () async {
        //arrange
        when(mockDataConnectionCkecker.hasConnection)
            .thenAnswer((_) async => true);
        //act
        final result = networkInfoImpl.isConnected;
        //assert
        verify(mockDataConnectionCkecker.hasConnection);
        expect(result, true);
      });
    });
  }
}
