//
//  ContentView.swift
//  CartoonSwiftui
//
//  Created by Madina Olzhabek on 20.01.2024.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct Cartoon: Identifiable{
    var id = UUID()
    var name = ""
    var year = ""
    var country = ""
    var flag = ""
    var imageOfCartoon = ""
    
    init(json:JSON){
        if let item = json["name"].string{
            name = item
        }
        if let item = json["year"].string{
            year = item
        }
        if let item = json["country"].string{
            country = item
        }
        if let item = json["flag"].string{
            flag = item
        }
        if let item = json["imageOfCartoon"].string{
            imageOfCartoon = item
        }

    }
    
}

struct CartoonRow: View{
    var cartoonItem: Cartoon
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: cartoonItem.imageOfCartoon))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 4){
                Text(cartoonItem.name)
                Text(cartoonItem.year)
                
                HStack{
                    
                    WebImage(url: URL(string: cartoonItem.flag))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 20)
                    Text(cartoonItem.country)
                }
            }
        }
    }
    
    
}


struct ContentView: View {
    @ObservedObject var cartoonsList = GetCartoon()
    
    var body: some View {
        NavigationView {
            List(cartoonsList.cartoonsArray){ cartoonItem in
                CartoonRow(cartoonItem: cartoonItem)
                 
            }
            .refreshable {
                self.cartoonsList.updateData()
            }
            .navigationTitle("Cartoon")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class GetCartoon: ObservableObject {
   @Published var cartoonsArray = [Cartoon]()
    
    init(){
        updateData()
    }
    
    func updateData(){
        let urlString = "https://demo7073178.mockable.io/get%D0%A1artoon"
        
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url!) { data,_, error in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            let json = JSON(data!)
            if let resultArray = json.array{
                self.cartoonsArray.removeAll()
                for item in resultArray{
                    let cartoonItem = Cartoon(json: item)
                    
                    DispatchQueue.main.async {
                        self.cartoonsArray.append(cartoonItem)
                    }
                }
            }
        }.resume()
        
    }
}
