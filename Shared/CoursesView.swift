//
//  CoursesView.swift
//  DesignCodeCourse
//
//  Created by Alex on 01/01/2021.
//

import SwiftUI

struct CoursesView: View {
    @State var show = false
    @State var selectedItem: Course? = nil
    @State var isDisable = false
    
    @Namespace var namespace
    @Namespace var namespaceNavigationLink
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif
    
    
    var body: some View{
        ZStack {
            #if os(iOS)
            if horizontalSizeClass == .compact {
                tabBar
            } else {
                sidebar
            }
            
            fullContent
                .background(VisualEffectBlur(blurStyle: .systemMaterial).edgesIgnoringSafeArea(.all))
            #else
            content
            fullContent
                .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
            #endif
        }
        .navigationTitle("Courses")
    }
    
    var content: some View {
        ScrollView {
            VStack(spacing: 0) {
                LazyVGrid (
                    columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                    spacing: 16
                ){
                    ForEach(courses) { item in
                        VStack {
                            CourseItem(course: item)
                                .matchedGeometryEffect(id: item.id, in: namespace, isSource: !show)
                                .frame(height: 200)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                                        show.toggle()
                                        selectedItem = item
                                        isDisable = true
                                    }
                                }
                                .disabled(isDisable)
                        }
                        .matchedGeometryEffect(id: "container-\(item.id)", in: namespace, isSource: !show)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                
                Text("Latest sections")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 240))]) {
                    ForEach(courseSections) { item in
                        #if os(iOS)
                        NavigationLink(destination: CourseDetail(course: Course(title: "Test", subtitle: "test", image: "", color: .red), namespace: namespaceNavigationLink)){
                            CourseRow(item: item)
                        }
                        #else
                        CourseRow(item: item)
                        #endif
                    }
                }.padding()
                
            }
            
        }
        .zIndex(1)
        .navigationTitle("Courses")
    }
    
    @ViewBuilder
    var fullContent: some View {
        if let course = selectedItem {
            ZStack(alignment: .topTrailing) {
                CourseDetail(course: course, namespace: namespace)
                
                CloseButton()
                    .padding(16)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                            show.toggle()
                            selectedItem = nil
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isDisable = false
                            }
                        }
                    }
            }
            .zIndex(2)
            .frame(maxWidth: 712)
            .frame(maxWidth: .infinity)
        }
    }
    
    var tabBar: some View{
        TabView{
            NavigationView {
                content
            }
            .tabItem {
                Image(systemName: "book.closed")
                Text("Courses")
            }
            
            NavigationView {
                CoursesList()
            }
            .tabItem {
                Image(systemName: "list.bullet.rectangle")
                Text("Tutorials")
            }
            
            NavigationView {
                CoursesList()
            }
            .tabItem {
                Image(systemName: "tv")
                Text("Livestreams")
            }
            
            NavigationView {
                CoursesList()
            }
            .tabItem {
                Image(systemName: "mail.stack")
                Text("Certificates")
            }
            
            NavigationView {
                CoursesList()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
    }
    
    @ViewBuilder
    var sidebar: some View {
        #if os(iOS)
        NavigationView {
            List {
                NavigationLink(destination: CoursesView()) {
                    Label("Courses", systemImage: "book.closed")
                }
                Label("Tutorials", systemImage: "list.bullet.rectangle")
                Label("Livestreams", systemImage: "tv")
                Label("Certificates", systemImage: "mail.stack")
                Label("Search", systemImage: "magnifyingglass")
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Learn")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.crop.circle")
                }
            })
            
            content
        }
        #endif
    }
    
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
