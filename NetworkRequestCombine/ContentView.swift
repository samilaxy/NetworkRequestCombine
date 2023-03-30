//
//  ContentView.swift
//  NetworkRequestCombine
//
//  Created by Noye Samuel on 26/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var selection = 0
    @StateObject private var viewModel: ViewModel
  //  var combineImp = CombineImp()
    init(dataService: MockImp) {
        _viewModel = StateObject(wrappedValue: ViewModel(dataService: dataService as DataServiceProtocol))
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .gray //UIColor(Color("NavColor"))
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                TabView(selection: $selection) {
                    List(viewModel.posts) { post in
                        Text(post.title).foregroundColor(.secondary)
                    }
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Posts")
                    }
                    .tag(0)
                    
                    List(viewModel.comments) { comment in
                        Text(comment.email).foregroundColor(.secondary)
                    }
                        .tabItem {
                            Image(systemName: "bookmark.circle.fill")
                            Text("Comments")
                        }
                        .tag(1)
                    
                    List(viewModel.users) { user in
                        Text(user.name).foregroundColor(.secondary)
                    }
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                        .tag(2)
                }  .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle("Dependency Injection", displayMode: .automatic)
                    .foregroundColor(.secondary)
                    .edgesIgnoringSafeArea(.all)
                    .padding(10)
                    .accentColor(.red)
                    .onAppear() {
                        UITabBar.appearance().barTintColor = UIColor(Color("NavColor"))
                    }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let dataService = MockImp()
    static var previews: some View {
        
        ContentView(dataService: dataService)
    }
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Post: Decodable,  Identifiable {
    let id: Int
    let userId: Int
    let title: String
}

struct Comment: Decodable, Identifiable {
    let id: Int
    let postId: Int
    let email: String
}

protocol DataServiceProtocol {
    func getUsers() -> AnyPublisher<[User], Error>
    func getPost(userId: Int) -> AnyPublisher<[Post], Error>
    func getComment(postId: Int) -> AnyPublisher<[Comment], Error>
}

class CombineImp {
    
    func getUsers() -> AnyPublisher<[User], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [User].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getPost(userId: Int) -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=\(userId)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [Post].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getComment(postId: Int) -> AnyPublisher<[Comment], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [Comment].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockImp : DataServiceProtocol {
    let testUsers: [User] = [User(id: 1, name: "Sam")]
    let testPosts: [Post] = [Post(id: 1, userId: 1, title: "Twitier")]
    let testCommets: [Comment] = [Comment(id: 1, postId: 1, email: "gbjdj@hjfj.com")]
    
    func getUsers() -> AnyPublisher<[User], Error> {
        Just(testUsers)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
    
    func getPost(userId: Int) -> AnyPublisher<[Post], Error> {
        Just(testPosts)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
    
    func getComment(postId: Int) -> AnyPublisher<[Comment], Error> {
        Just(testCommets)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }

}

class ViewModel: ObservableObject {
    
    @Published var comments : [Comment] = []
    @Published var posts : [Post] = []
    @Published var users : [User] = []
    
    var dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        self.getComments()
        self.getUsers()
        self.gePosts()
    }
    
    var cancellables = Set<AnyCancellable>()
    func getUsers(){
        dataService.getUsers()
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedUsers in
                self?.users = returnedUsers
            }.store(in: &cancellables)
        
        print(users)
    }
    
    func getComments(){
        dataService.getComment(postId: 2)
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedComments in
                self?.comments = returnedComments
             }.store(in: &cancellables)
        
        print(comments)
    }
    
    func gePosts(){
        dataService.getPost(userId: 2)
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedPosts in
                self?.posts = returnedPosts
            }.store(in: &cancellables)
        
        print(posts)
    }
}


struct AwaitAsyncImp {
    
}
