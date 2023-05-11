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
    init(dataService: CombineImp) {
        _viewModel = StateObject(wrappedValue: ViewModel(dataService: dataService as! DataServiceProtocol))
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
    
    static let dataService = CombineImp()
    static var previews: some View {
        
        ContentView(dataService: dataService)
    }
}









struct AwaitAsyncImp {
    
}
