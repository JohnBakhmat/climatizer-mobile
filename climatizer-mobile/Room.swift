//
//  Room.swift
//  climatizer-mobile
//
//  Created by Евгений Бахмат on 21.12.2021.
//

import SwiftUI
import SwiftUIRouter
import Alamofire

struct RoomType:Decodable, Hashable{
    let id:Int
    let title:String
    let description:String
    let temperature:Int
    let humidity:Int
    let carbonMonoxide:Int
    enum CodingKeys: String,CodingKey{
        case id = "id"
        case title = "name"
        case description = "description"
        case temperature = "temperature"
        case humidity = "humidity"
        case carbonMonoxide = "co"
    }
}
struct Room: View {
    var id: Int = 1
    @State private var title:String = ""
    @State private var description:String = ""
    @State private var temperature = 1
    @State private var humidity = 1
    func fetchData(){
        let url = URL(string:"http://192.168.0.106:3099/mobile/get/\(id)")!
        AF.request(url, method:.get).responseDecodable(of: RoomType.self){
            (response) in
            switch response.result{
            case .success:
                guard let temp = response.value?.temperature else {return}
                guard let hum = response.value?.humidity else {return}
                guard let t =  response.value?.title else{return}
                guard let desc =  response.value?.description else{return}
                self.temperature = temp
                self.description = desc
                self.humidity = hum
                self.title = t
            case .failure(let error):
                print("You are failure \(error)")
            }
        }
    }

    var body: some View {
        
        return ZStack{
            GoBackButton().position(x:30,y: -10)
            VStack{

                Text("\(title)").font(.title)
                Text("\(description)").font(.title3).frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                Text("Температура").font(.title2)
                Picker("Температура", selection: $temperature) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }.pickerStyle(.wheel)
                
                Text("Вологість").font(.title2)
                Picker("Вологість", selection: $humidity) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }.pickerStyle(.wheel)
                
                Button(action:{
                    debugPrint("Temperature \(temperature)C")
                    debugPrint("Humidity \(self.humidity)%")
                }){
                    SubmitButtonContent()
                }
                
                
            }.frame(maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading).padding()

        }.padding().onAppear
        {fetchData()}


    }
}
struct SubmitButtonContent: View {
    var body: some View {
        Text("Зберігти").font(.headline).foregroundColor(.white).padding().frame(width: 220, height: 60).background(Color.green).cornerRadius(15.0)
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room()
    }
}

struct GoBackButton: View {
    @State var isGoBackClicked:Bool = false
    var body: some View {
        Button(action:{
            self.isGoBackClicked = true
        }){
            Text("Go Back")
            if(isGoBackClicked){
                Navigate(to: "/workspace")
            }
            
        }.frame(width: 100, height: 30, alignment: .center)
    }
}
