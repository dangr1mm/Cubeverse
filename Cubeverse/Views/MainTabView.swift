//
//  MainTabView.swift
//  Cubeverse
//
//  Created by Dan Grimm on 16/07/22.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var factory: ViewModelFactory
    
    var body: some View {
        TabView {
            NavigationView {
                PostsList(viewModel: factory.makePostsViewModel())
                    
            }
            .tabItem {
                Label("Posts", systemImage: "list.dash").frame(width: 40, height: 40)
            }
            NavigationView {
                PostsList(viewModel: factory.makePostsViewModel(filter: .favorites))
                    
            }
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
            ProfileView(viewModel: factory.makeProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(ViewModelFactory.preview)
    }
}
