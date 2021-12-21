//
//  climatizer_mobileApp.swift
//  climatizer-mobile
//
//  Created by Евгений Бахмат on 04.12.2021.
//

import SwiftUI
import SwiftUIRouter

@main
struct climatizer_mobileApp: App {
    var body: some Scene {
        WindowGroup {
            Router{
            SwitchRoutes{

                Route("workspace"){
                    Workspace()
                }
                Route("room/:id"){
                    info in Room(id: Int(info.parameters["id"]!)!)
                }
                Route{
                    AuthPage()
                }
            }
                
        }
        }
    }
}
