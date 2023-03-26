//
//  ContentView.swift
//  NetworkRequestCombine
//
//  Created by Noye Samuel on 26/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct User: Decodable {
    let id: Int
    let name: String
}

struct Post: Decodable {
    let id: Int
    let userId: String
    let title: String
}

struct Comment: Decodable {
    let id: String
    let postId: String
    let email: String
}


struct CombineImp {
    
    func getUsers() -> AnyPublisher<[User], Error> {
        
    }
}

struct AwaitAsyncImp {
    
}
