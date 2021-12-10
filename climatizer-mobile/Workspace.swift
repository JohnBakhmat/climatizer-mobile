//
//  Workspace.swift
//  climatizer-mobile
//
//  Created by Евгений Бахмат on 07.12.2021.
//

import SwiftUI
let defaults = UserDefaults.standard


struct Workspace: View {
    
    let token = defaults.string(forKey: "accessToken") ?? "Nothing"
    var body: some View {
        Text(token)
    }
}

struct Workspace_Previews: PreviewProvider {
    static var previews: some View {
        Workspace()
    }
}
