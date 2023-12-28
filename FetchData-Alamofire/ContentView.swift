//
//  ContentView.swift
//  FetchData-Alamofire
//
//  Created by Hmoo Myat Theingi on 27/12/2023.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI
import SwiftyJSON

struct ContentView: View {
    @ObservedObject var obs = Observer()
    var body: some View {
        NavigationView{
            List(obs.datas) { i in
                Card(name: i.name,url: i.url)
            }
            .navigationTitle("JSON Parse")
        }
        
    }
}

class Observer:ObservableObject{
    @Published var datas = [Datatype]()
    init(){
        AF.request("https://api.github.com/users/hadley/orgs").responseData { data in
            let json = try! JSON(data: data.data!)
            for i in json{
                let data = Datatype(id: i.1["id"].intValue, name: i.1["login"].stringValue, url: i.1["avatar_url"].stringValue)
                self.datas.append(data)
                print(i.1)
            }
        }
    }
       
    
}

struct Datatype:Identifiable{
    var id: Int
    var name:String
    var url:String
    
}

struct Card:View{
    
    var name = ""
    var url = ""
    
    var body: some View{
        HStack{
            AnimatedImage(url: URL(string: url)!)
                .resizable()
                .frame(width: 60,height: 60)
                .clipShape(Circle())
                .shadow(radius: 20)
            Text(name)
                .fontWeight(.heavy)
        }
    }
}

#Preview {
    ContentView()
}
