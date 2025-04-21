////  BarberView.swift
////  TEST/Barber_App
////
////  Created by user on 3/21/24.

import SwiftUI

struct BarberAppView: View {
    var body: some View {
        NavigationView {
            List {
                
                    ProfileHeader_Section()
                    PriceChanger_Section()
                    NextAppointment_Section()
                        .environmentObject(ClientArrayModel())
                    UpcomingAppointments_Section()
                        .environmentObject(ClientArrayModel())
                        .environmentObject(PendingArrayModel())
                    Clientele_Section()
                
//                .listStyle(GroupedListStyle())
//                .padding(.top, geo.safeAreaInsets.top)
//                
            }
            
            .padding(.top, -25)
        }
        .scrollIndicators(.hidden)
    }
}



//Name and start date of the barber
struct ProfileHeader_Section: View {
    var body: some View {
        Section {
        } footer: {
            VStack {
                Text("Zachary Iyasere")
                    .modifier(CustomTextModifier(size: 30, color: .blue))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                Text("Barber Since 2014")
                    .modifier(CustomTextModifier(size: 15, color: .white))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .italic()
            }
        }
        .listRowInsets(.init(top: -10, leading: 5, bottom: 7, trailing: 20))
    }
}

//Section to change the price
struct PriceChanger_Section: View {
    @State private var price = 30
    @State private var priceColor: Color = .white

    var body: some View {
        Section {
            HStack {
                Button {
                    if price > 0 {
                        price -= 5
                        priceColor = .red
                    }
                } label: {
                    Image(systemName: "minus")
                        .modifier(CustomTextModifier(size: 28, color: .red))
                        .bold()
                }
                .buttonStyle(.borderless)

                Spacer()

                Text("$ \(price)")
                    .modifier(CustomTextModifier(size: 45, color: priceColor))
                    .bold()

                Spacer()

                Button {
                    price += 5
                    priceColor = .white
                } label: {
                    Image(systemName: "plus")
                        .modifier(CustomTextModifier(size: 28, color: .green))
                        .bold()
                }
                .buttonStyle(.borderless)
            }
            .swipeActions(edge: .trailing){
                Button{
                    updatePrice(price)
                }label:{
                    Image(systemName: "dollarsign.arrow.circlepath")
                        .foregroundColor(.white)
                }
                .tint(.green)
            }
            
        }
        header: {
            Text("Current Price: $30")
                .foregroundColor(.white)
        }
        .listSectionSpacing(.custom(15))
    }
}

//Section that displays the next appointment in the barber queue
struct NextAppointment_Section: View{
    @EnvironmentObject var clientArrayModel: ClientArrayModel
    @State private var nextAppointment: clientData? = nil
    
    var body: some View{
        Section{
            
            //Parent Stack of the next appointment
            VStack (alignment: .leading){
                HStack(alignment: .center) {
                    if nextAppointment != nil{
                        VStack{
                            HStack(alignment: .center) {
                                Text("\(nextAppointment!.name)")
                                    .modifier(CustomTextModifier(size: 17, color: .white))
                                    .bold()
                                
                                Spacer()
                                
                                HStack {
                                    Text("(123)456-7890")
                                        .modifier(CustomTextModifier(size: 13, color: .blue))
                                        .bold()
                                }
                            }
                            .cornerRadius(7)
                            
                            
                            //date and time labels HSTACK
                            HStack{
                                HStack {
                                    Image(systemName: "calendar")
                                        .modifier(CustomTextModifier(size: 10, color: .white))
                                    
                                    Text("Date")
                                        .modifier(CustomTextModifier(size: 10, color: .white))
                                        .padding(.leading, -5)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "clock")
                                        .modifier(CustomTextModifier(size: 10, color: .white))
                                        .bold()
                                    
                                    Text("Time")
                                        .modifier(CustomTextModifier(size: 10, color: .white))
                                        .padding(.leading, -5)
                                }
                            }
                            .padding(.top, 1)
                            
                            
                            HStack{
                                Text("Jan 3, 2024")
                                    .modifier(CustomTextModifier(size: 13, color: .green))
                                    .bold()
                                
                                Spacer()
                                Text("4:00 PM")
                                    .modifier(CustomTextModifier(size: 13, color: .green))
                                    .bold()
                            }
                        }
                    }
                    
                    else{
                        Text("There are no appointments")
                            .italic()
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                if clientArrayModel.clientArray.first != nil{
                    nextAppointment = clientArrayModel.clientArray.first
                }
            }
            .onChange(of: clientArrayModel.clientArray){
                if clientArrayModel.clientArray.isEmpty{
                    nextAppointment = nil
                }
            }
 // Update
.swipeActions(edge: .leading) {
    Button(role: .destructive) {
        if let index = clientArrayModel.clientArray.firstIndex(of: nextAppointment!) {
            cancelAppointment(appointment: clientArrayModel.clientArray[index], isPending: false)
        }
    } label: {
        Image(systemName: "circle.slash")
            .font(.system(size: 15))
            .foregroundColor(.white)
            .bold()
    }
    .tint(.red)
}


            .swipeActions(edge: .trailing){
                Button{}label:{
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .bold()
                }
                .tint(.orange)
            }
            
        }
        header:{
            Text("NEXT APPOINTMENT")
                .foregroundColor(.white)
        }
    }
}

//List of the next n appointments
struct UpcomingAppointments_Section: View{
    @State private var pendOrApp: String = "Approved"
    @EnvironmentObject var pendingArrayModel: PendingArrayModel
    @EnvironmentObject var clientArrayModel: ClientArrayModel
    @State private var showApp = false
    let s = ["Approved", "Pending"]

    // Update
    func cancelAppointment(appointment: clientData, isPending: Bool) {
    if isPending {
        if let index = pendingArrayModel.pendingArray.firstIndex(of: appointment) {
            pendingArrayModel.pendingArray.remove(at: index)
        }
    } else {
        if let index = clientArrayModel.clientArray.firstIndex(of: appointment) {
            clientArrayModel.clientArray.remove(at: index)
        }
    }
}

    
    var body: some View{
        
            Section{}
            header:{
                Text("Upcoming Appointments")
                    .foregroundColor(.white)
                    .padding(.leading, 20)
            }
            footer:{
                Picker(selection: $pendOrApp, label: Text("Data")) {
                    ForEach(s, id: \.self) { imageName in
                        Text("\(imageName)")
                            .rotationEffect(Angle(degrees: 90))
                    }
                }
                .frame(maxWidth: .infinity)
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .clipped()
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: -10, trailing: 0))
            
            
            
            Section{
                if pendOrApp == "Pending"{
                    ForEach(pendingArrayModel.pendingArray/*.prefix(5)*/, id: \.self){ client in
                        VStack {
                            HStack{
                                VStack(alignment: .leading, spacing: 3){
                                    Text("\(client.name)")
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                    Text("@Sacramento")
                                        .font(.system(size: 13))
                                        .foregroundColor(.orange)
                                        .italic()
                                        .padding(.top, -2)
                                }
                                
                                Spacer()
                                
                                VStack (alignment: .trailing){
                                    Text("Wed, Jan 7")
                                        .font(.system(size: 15))
                                        .padding(.top, 1)
                                    
                                    Text("3:00pm")
                                        .font(.system(size: 13))
                                }
                                
                            }
                            
                        }
                        .padding([.top, .bottom], 1)
                        .swipeActions(edge: .trailing){
                            Button{}label:{
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(.white)
                            }
                            .tint(.yellow)
                        }
                        
                        .swipeActions(edge: .leading){
                            Button(role: .destructive){
                                if let index = pendingArrayModel.pendingArray.firstIndex(of: client) {
                                    pendingArrayModel.pendingArray.remove(at: index)
                                }
                            }label:{
                                ZStack {
                                    Circle()
                                        .fill(Color.red) // Background red circle
                                        .frame(width: 25, height: 25) // Adjust size as needed
                                    Image(systemName: "circle")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(.red)
                        }
                    }
                }
                
                
                //Pending apointment list
                if pendOrApp == "Approved"{
                    ForEach(clientArrayModel.clientArray.count > 1 ? clientArrayModel.clientArray.suffix(from: 1)/*.prefix(5)*/: [], id: \.self) {client in
                        
                        Button {
                            showApp.toggle()
                        } label: {
                            VStack(alignment:.leading, spacing: 3) {
                                HStack {
                                    VStack(alignment: .leading){
                                        Text("\(client.name)")
                                            .font(.system(size: 15))
                                            .bold()
                                        
                                        Text("\(client.number)")
                                            .font(.system(size: 13))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing){
                                        Text("Mon, Feb 3")
                                            .font(.system(size: 15))
                                            .padding(.top, 1)
                                        
                                        
                                        
                                        Text("4:00 AM")
                                            .font(.system(size: 13))
                                    }
                                    
                                }
                                .foregroundColor(.white)
                                
                            }.padding([.top, .bottom], 1)
                        }
                        .swipeActions(edge: .trailing){
                            Button{}label:{
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                            .tint(.green)
                        }
                        
                        .swipeActions(edge: .trailing){
                            Button{}label:{
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(.white)
                            }
                            .tint(.yellow)
                        }
 // Update
.swipeActions(edge: .leading) {
    Button(role: .destructive) {
        cancelAppointment(appointment: client, isPending: pendOrApp == "Pending")
    } label: {
        Image(systemName: "circle.slash")
    }
    .tint(.red)
}

                        
                    }
                    .id(clientArrayModel.clientArray)
                }
                
                //Calendar Button
                HStack{
                    Image(systemName: "calendar")
                        .modifier(CustomTextModifier(size: 20, color: .blue))
                    
                    Text("Calendar")
                        .modifier(CustomTextModifier(size: 20, color: .blue))
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                //            .background(
                //                NavigationLink("", destination: barber_calendarButton_View())
                //                    .opacity(0)
                //            )
                
            }
            
        
    }
}

//Clientele Button
//Destination -> List of Clientele page
struct Clientele_Section: View{
    
    var body: some View{
        Section{
            HStack {
                Image(systemName: "person.3.fill")
                    .modifier(CustomTextModifier(size: 13, color: .blue))
                    .frame(maxWidth: 25)
                
                Text("Clientele")
                    .modifier(CustomTextModifier(size: 20, color: .blue))
                    .bold()
            }
        }
        header:{
            Text("Clients")
                .foregroundColor(.white)
        }
        .background(
            NavigationLink("", destination: clientListView())
                .opacity(0)
        )
    }
}


#Preview {
    BarberAppView()
        .environmentObject(PendingArrayModel())
}
