import Foundation
import Swinject
import Common

public class TeamsAssembly: DIAssembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(TeamsRemoteDataSource.self) { _ in
            TeamsRemoteDataSourceImpl()
        }
        
        container.register(TeamsRepository.self) { resolver in
            TeamsRepositoryImpl(remoteDataSource: resolver.resolve(TeamsRemoteDataSource.self)!)
        }
        
        container.register(GetTeamsUseCase.self) { resolver in
            GetTeamsUseCase(repository: resolver.resolve(TeamsRepository.self)!)
        }
        
        container.register(CreateTeamUseCase.self) { resolver in
            CreateTeamUseCase(repository: resolver.resolve(TeamsRepository.self)!)
        }
        
        container.register(CloudinaryServiceProtocol.self) { _ in
            CloudinaryService()
        }
        
        container.register(TeamsViewModel.self) { resolver in
            TeamsViewModel(
                getTeamsUseCase: resolver.resolve(GetTeamsUseCase.self)!,
                createTeamUseCase: resolver.resolve(CreateTeamUseCase.self)!,
                cloudinaryService: resolver.resolve(CloudinaryServiceProtocol.self)!
            )
        }
    }
}
