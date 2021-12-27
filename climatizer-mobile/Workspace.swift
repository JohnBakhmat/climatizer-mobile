//
//  Workspace.swift
//  climatizer-mobile
//
//  Created by Евгений Бахмат on 07.12.2021.
//

import SwiftUI
import SwiftUIRouter
import Alamofire
let defaults = UserDefaults.standard

struct Workspace_Previews: PreviewProvider {
    static var previews: some View {
        Workspace()
    }
}

struct Workspace: View {
    weak var timer: Timer?
    
    @State var rooms:[RoomType] = []
    
    
    
    func fetchData(){
        let url = URL(string:"http://192.168.0.106:3099/mobile/get")!
        AF.request(url, method:.get).responseDecodable(of: [RoomType].self){
            (response) in
            switch response.result{
            case .success:
                guard let data = response.value else {return}
                rooms = data
            case .failure(let error):
                print("You are failure \(error)")
            }
        }
    }
    var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 2)
    let token = defaults.string(forKey: "accessToken") ?? "Nothing"
    var body: some View {
        ScrollView{
            
            LazyVGrid(columns:columns){
                ForEach(rooms, id: \.self){ room in
                    GridCell(id:room.id,roomName: room.title, temperature: room.temperature, humidity: room.humidity, CO2: room.carbonMonoxide)
                }
            }.padding(10)
            //203, 238, 243
        }.background(Color.init(red: 203/255, green: 238/255, blue: 243/255))
        .onAppear{
            fetchData()
            Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true){_ in
                fetchData()
            }
            
        }
    }
}

struct RoomName: View {
    var value: String
    var body: some View {
        Text("\(value)")
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .padding(10)
            .font(.title3)
            .foregroundColor(.white)
    }
}

struct GridCell: View{
    var id: Int
    var roomName: String
    var temperature: Int
    var humidity: Int
    var CO2: Int
    let degreeSymbol:Character = "\u{00b0}"

    @State var isClicked:Bool = false
    var body: some View{
        if(isClicked){
            Navigate(to: "/room/\(id)")
        }
        Button(action:{
            self.isClicked = true
        }){
        VStack(alignment:.leading,spacing: 0){
            RoomName(value:roomName)
            Temperature(value: temperature)
            
            HStack(alignment:.bottom){
                
                Humidity(value: humidity)
                
                CO2Display(value: CO2)
            
            }.frame(maxWidth: .infinity, maxHeight: 200, alignment: .leading)
        }
        .frame(maxWidth: .infinity,
               minHeight: 200,
               alignment: .topLeading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.green.opacity(0.8),
                             .green.opacity(1)]),
                startPoint: .top,
                endPoint: .bottom)
        )
        .cornerRadius(15).foregroundColor(.white)
        }
    }
    
}




struct Temperature: View {
    var value: Int
    
    var body: some View {
        Text("\(value)\u{00b0}")
            .font(.system(size:60))
            .frame(maxWidth:.infinity, alignment: .topLeading)
            .padding(.leading,10)
    }
}

struct Humidity: View {
    var value: Int
    var body: some View {
        VStack{
            Image("HumidityIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("\(value)%").fontWeight(.semibold).fixedSize()
                .frame(maxHeight:40,alignment:.center)
            
        }.padding(10).frame(maxWidth:.infinity,maxHeight: 100)
    }
}

struct CO2Display: View {
    var value: Int
    var body: some View {
        VStack{
            Image("CO2Icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("\(value)%").fontWeight(.semibold).fixedSize().frame(maxHeight:40,alignment:.center)
            
        }.padding(10).frame(maxWidth:.infinity,maxHeight: 100,alignment: .top)
    }
}
