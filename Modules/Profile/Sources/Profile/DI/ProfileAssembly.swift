import Foundation
import Swinject
import Common

public class ProfileAssembly: DIAssembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(ProfileRemoteDataSource.self) { _ in
            ProfileRemoteDataSourceImpl()
        }

        container.register(ProfileRepository.self) { resolver in
            ProfileRepositoryImpl(remoteDataSource: resolver.resolve(ProfileRemoteDataSource.self)!)
        }

        container.register(GetProfileUseCase.self) { resolver in
            GetProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }

        container.register(UpdateProfileUseCase.self) { resolver in
            UpdateProfileUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }

        container.register(UploadProfilePhotoUseCase.self) { resolver in
            UploadProfilePhotoUseCase(repository: resolver.resolve(ProfileRepository.self)!)
        }

        container.register(ProfileViewModel.self) { resolver in
            ProfileViewModel(
                getProfileUseCase: resolver.resolve(GetProfileUseCase.self)!,
                updateProfileUseCase: resolver.resolve(UpdateProfileUseCase.self)!,
                uploadProfilePhotoUseCase: resolver.resolve(UploadProfilePhotoUseCase.self)!
            )
        }
    }
}
