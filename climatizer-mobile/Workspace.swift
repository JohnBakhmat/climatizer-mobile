//
//  Workspace.swift
//  climatizer-mobile
//
//  Created by Евгений Бахмат on 07.12.2021.
//

import SwiftUI
let defaults = UserDefaults.standard


struct Workspace: View {
    var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 2)
    let token = defaults.string(forKey: "accessToken") ?? "Nothing"
    var body: some View {
        ScrollView{
            LazyVGrid(columns:columns){
                RequestCell()
                RequestCell()
                RequestCell()
                RequestCell()
                RequestCell()
                RequestCell()
            }.padding(10)
            //203, 238, 243
        }.background(Color.init(red: 203/255, green: 238/255, blue: 243/255))
    }
}
struct RoomName: View {
    var body: some View {
        Text("RoomName")
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .padding(10)
            .font(.title3)
            .foregroundColor(.white)
    }
}

struct RequestCell: View{
//    var image: String
//    var title: String
//    var description: String
    let degreeSymbol:Character = "\u{00b0}"
    var body: some View{
        VStack(alignment:.leading,spacing: 0){
            RoomName()
            Text("6\u{00b0}")
                .font(.system(size:60))
                .frame(maxWidth:.infinity, alignment: .topLeading)
                .padding(.leading,10)
            
            HStack(alignment:.bottom){
                
                VStack{
                Image("HumidityIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
    
                    Text("50%").fontWeight(.semibold).fixedSize()
                        .frame(maxHeight:40,alignment:.center)
                    
                }.padding(10).frame(maxWidth:.infinity,maxHeight: 100)
                
                VStack{
                    Image("CO2Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text("50%").fontWeight(.semibold).fixedSize().frame(maxHeight:40,alignment:.center)
                    
                }.padding(10).frame(maxWidth:.infinity,maxHeight: 100,alignment: .top)
            
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

struct Workspace_Previews: PreviewProvider {
    static var previews: some View {
        Workspace()
    }
}


