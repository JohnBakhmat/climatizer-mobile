//
//  ContentView.swift
//  climatizer-mobile
//
//  Created by Евгений Бахмат on 04.12.2021.
//

import SwiftUI
import Alamofire
import SwiftUIRouter

let storedUsername = "johnbakhmat"
let storedPassword = "123456"

struct RequestResponse:Decodable{
    let idToken:String
    
    
    enum CodingKeys: String,CodingKey{
        case idToken = "idToken"
    }
}



let lightGreyColor = Color(red: 239/255, green: 243.0/255, blue: 244.0/255.0, opacity: 1.0)

struct AuthPage: View {
    func logIn(username: String, password: String){
        
        let parameters: [String:String]=[
            "email":username,
            "password":password
        ]
        
        let defaults = UserDefaults.standard
        AF.request(
            "http://192.168.0.106:3099/auth/login",
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        ).responseDecodable(of: RequestResponse.self){
            (response) in
            switch response.result{
            case .success:
                guard let accessToken = response.value?.idToken else { return }
                print(accessToken)
                defaults.set(accessToken,forKey: "accessToken")
                self.authenticationDidSucceed = true
                self.authenticationDidFail = false
                
                
            case let .failure(error):
                self.authenticationDidFail = true
                        print(error)
            }
        }
    }
    @State var username: String = "yevhenii.bakhmat@nure.ua"
    @State var password: String = "9012002Bjy"
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    WelcomeText()
                    UserImage()
                    UsernameTextField(username: $username)
                    PasswordSecureField(password: $password)
                    
                    if(authenticationDidFail){
                        Text("Information not correct. Try again!")
                            .offset(y:-10)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        print("Button Tapped")
                        logIn(username:self.username, password: self.password)
                    }){
                        LoginButtonContent()
                    }
                    if(authenticationDidSucceed){
                        Navigate(to: "/workspace")
                    }
                    
                    
                }.padding()
                
                if(authenticationDidSucceed){
                    Text("Login succeeded!")
                        .font(.headline)
                        .frame(width: 250, height: 80)
                        .background(Color.green)
                        .cornerRadius(20.0)
                        .foregroundColor(.white)
                        .animation(.default)
                }
            }
            
        }.offset(y: -keyboardResponder.currentHeight*0.9)
    }
}
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthPage()
    }
}
#endif

struct WelcomeText: View {
    var body: some View {
        Text("Welcome!").font(.largeTitle).fontWeight(.semibold).padding(.bottom,20)
    }
}

struct UserImage: View {
    var body: some View {
        Image("userImage").resizable().aspectRatio(contentMode: .fill).frame(width: 150, height: 150).clipped().cornerRadius(150).padding(.bottom,75)
    }
}

struct LoginButtonContent: View {
    var body: some View {
        Text("LOGIN").font(.headline).foregroundColor(.white).padding().frame(width: 220, height: 60).background(Color.green).cornerRadius(15.0)
    }
}

struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom,20)
    }
}

struct PasswordSecureField: View {
    
    @Binding var password: String
    
    var body: some View {
        SecureField("Password",text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom,20)
    }
}
