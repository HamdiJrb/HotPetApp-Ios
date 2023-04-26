//
//  SettingsView.swift
//  Hotpet
//
//  Created by Grim on 29/3/2023.
//

import SwiftUI

struct SettingsView: View {
    
    // VARIABLES
    let user: User = loadSession()!
    
    
    @State private var showingAlert = false
    @State private var alert: Alert?
    
    @State private var preferredDistance: Double = loadSession()?.preferredDistance != nil ? Double(loadSession()!.preferredDistance!) : 500
    
    @State private var pref = 1.0
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @ObservedObject var ageSlider = CustomSlider(
        start: 0,
        end: 20,
        startPosition:
            loadSession()?.preferredAgeMin != nil ?
        Double(loadSession()!.preferredAgeMin!) / 20 : 1,
        endPosition:
            loadSession()?.preferredAgeMax != nil ?
        Double(loadSession()!.preferredAgeMax!) / 20 : 20
    )
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                VStack {
                    Spacer(minLength: 60)
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark mode")
                            .font(.headline)
                    }
                    Spacer(minLength: 60)
                }
                Text("Distance : \(preferredDistance, specifier: "%.0f") KM")
                    .font(.headline)
                Slider(value: $preferredDistance, in: 0...500, step: 1)
                    .padding()
                Spacer(minLength: 60)
                let lowHandle = Int(abs(round(ageSlider.lowHandle.currentValue < ageSlider.highHandle.currentValue ? ageSlider.lowHandle.currentValue : ageSlider.highHandle.currentValue)))
                let highHandle = Int(abs(round(ageSlider.lowHandle.currentValue > ageSlider.highHandle.currentValue ? ageSlider.lowHandle.currentValue : ageSlider.highHandle.currentValue)))
                HStack{
                    Text("Age min : " + String(lowHandle))
                        .font(.headline)
                    Spacer()
                    Text("Age max : " + String(highHandle))
                        .font(.headline)
                }
                Spacer(minLength: 50)
                HStack(alignment: .center) {
                    Spacer()
                    SliderView(slider: ageSlider)
                    Spacer()
                }
                Spacer(minLength: 90)
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        saveChanges()
                    }) {
                        Text("Save changes")
                    }
                    .alert(isPresented: $showingAlert) {
                        alert!
                    }
                    .frame(width: 285)
                    .padding(10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    Spacer()
                }
            }
            .onAppear(perform: {
                preferredDistance = loadSession()?.preferredDistance != nil ? Double(loadSession()!.preferredDistance!) : 500
            })
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .padding()
        }.navigationBarTitle("Settings")
    }
    
    func saveChanges() {
        let preferredAgeRangeLowHandle = Int(abs(round(ageSlider.lowHandle.currentValue < ageSlider.highHandle.currentValue ? ageSlider.lowHandle.currentValue : ageSlider.highHandle.currentValue)))
        let preferredAgeRangeHighHandle = Int(abs(round(ageSlider.lowHandle.currentValue > ageSlider.highHandle.currentValue ? ageSlider.lowHandle.currentValue : ageSlider.highHandle.currentValue)))
        
        var userToSave: User = loadSession()!
        userToSave.preferredDistance = Int(preferredDistance)
        userToSave.preferredAgeMin = preferredAgeRangeLowHandle
        userToSave.preferredAgeMax = preferredAgeRangeHighHandle
        
        UserViewModel.sharedInstance.updatePreferredParams(
            email: userToSave.email,
            preferredAgeMin: userToSave.preferredAgeMin!,
            preferredAgeMax: userToSave.preferredAgeMax!,
            preferredDistance: userToSave.preferredDistance!
        ) { success in
            if success {
                saveSession(user: userToSave)
                alert = AlertMaker.makeAlert(
                    title: "Success",
                    message: "Changes saved !"
                )
                showingAlert = true
            } else {
                alert = AlertMaker.makeAlert(
                    title: "Error",
                    message: "Changes couldn't be saved !"
                )
                showingAlert = true
            }
        }
    }
}

struct SliderView: View {
    @ObservedObject var slider: CustomSlider
    
    var body: some View {
        RoundedRectangle(cornerRadius: slider.lineWidth)
            .fill(Color.gray.opacity(0.2))
            .frame(width: slider.width, height: slider.lineWidth)
            .overlay(
                ZStack {
                    //Path between both handles
                    SliderPathBetweenView(slider: slider)
                    
                    //Low Handle
                    SliderHandleView(handle: slider.lowHandle)
                        .highPriorityGesture(slider.lowHandle.sliderDragGesture)
                    
                    //High Handle
                    SliderHandleView(handle: slider.highHandle)
                        .highPriorityGesture(slider.highHandle.sliderDragGesture)
                }
            )
    }
}

struct SliderHandleView: View {
    @ObservedObject var handle: SliderHandle
    
    var body: some View {
        Circle()
            .frame(width: handle.diameter, height: handle.diameter)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
            .scaleEffect(handle.onDrag ? 1.3 : 1)
            .contentShape(Rectangle())
            .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
    }
}

struct SliderPathBetweenView: View {
    @ObservedObject var slider: CustomSlider
    
    var body: some View {
        Path { path in
            path.move(to: slider.lowHandle.currentLocation)
            path.addLine(to: slider.highHandle.currentLocation)
        }
        .stroke(Color("AccentColor"), lineWidth: slider.lineWidth)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
