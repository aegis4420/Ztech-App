import SwiftUI


/*
 struct "clientView"
 type: View
 - View of the applicatons homescreen
 */
struct clientView: View {
    
    @StateObject var data = GridViewMode()
    @State var selected = ""
    @State var show = false
    @State var disabledButtons = false
    @State var detailHeight: Double = 400.0
    @State var showBooking = false
    @State var showHistory = false
    @State var showAppointment = false
    @State var selectDate: Date = Date()
    @State var theMonth = 0
    @State var dateofdate: Date = Date()
    @State var showCancel_Bool = false
    @State var appointment_isBooked = true
    @State private var currentPrice = 0
    @State private var chan: Int = 0
    
    @State private var path = NavigationPath()

    // fetching the current price from DB
    // data should look like this:
    // { "price": 45 }
    func fetchCurrentPrice() {
        guard let url = URL(string: "https://your-api-url.com/get-price") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching price: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let price = json["price"] as? Int else {
                print("Failed to parse price")
                return
            }

            DispatchQueue.main.async {
                self.currentPrice = price
            }
        }.resume()
    }


    
    var amColor = Color(red:134/255, green: 171/255, blue: 247/255)
    var pmColor = Color(red:134/255, green: 171/255, blue: 247/255)
    var todaysDate = Date()
    var apps = appData
    
    var body: some View {

        
        NavigationView {
            
            List{
                
                /*
                 Name of the client and year they joined
                 */
                Section{} footer: {
                    VStack (alignment: .leading, spacing: 1){
                        HStack{
                            Image(systemName: "person.fill")
                                .modifier(CustomTextModifier(size: 20, color: .white))
                                .bold()
                                .padding(.trailing, 5)
                            
                            Text("Zachary Iyasere")
                                .modifier(CustomTextModifier(size: 30, color: .white))
                                .bold()
                                .padding(.leading, -5)
                        }
                        
                        
                        Text("Joined 2014")
                            .modifier(CustomTextModifier(size: 11, color: .white))
                            .bold()
                            .italic()
                    }
                }
                .listRowInsets(.init(top: -10, leading: 5, bottom: 7, trailing: 20))
                
                
                
                //Phone number and client's city location
                //NEXT: Make this a button to the users detail/information page
                Section{
                    VStack{
                        HStack(alignment: .bottom) {
                            
                            HStack{
                                Image(systemName: "phone.fill")
                                    .modifier(CustomTextModifier(size: 10, color: .white))
                                    .bold()
                                
                                Text("(916)896-9789")
                                    .modifier(CustomTextModifier(size: 13, color: .white))
                                    .bold()
                                    .padding(.leading, -3)
                            }
                            
                            Spacer()
                            
                            Text("347")
                                .modifier(CustomTextModifier(size: 13, color: .green))
                                .bold()
                            
                            
                        }
                        .padding(.leading, 10)
                        
                        
                        
                        HStack {
                            HStack(alignment: .top){
                                Image(systemName: "mappin.and.ellipse")
                                    .modifier(CustomTextModifier(size: 10, color: .white))
                                    .bold()
                                
                                Text("Sacramento, CA")
                                    .modifier(CustomTextModifier(size: 13, color: .white))
                                    .bold()
                                    .padding(.leading, -3)
                            }
                            
                            Spacer()
                            
                            Text("12")
                                .modifier(CustomTextModifier(size: 13, color: .red))
                                .bold()
                        }
                        .padding(.leading, 10)
                        
                    }
                }
                .listRowInsets(.init(top: 5, leading: 5, bottom: 7, trailing: 20))
                .listSectionSpacing(.custom(0))
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
             
                
                
                
                
                
                
                //List section to show upcoming appointments, book new appointments, and delete any appointments
                Section{
                    if appointment_isBooked{
                        VStack(alignment: .leading){
                            Text("Next appointment")
                                .modifier(CustomTextModifier(size: 13, color: .white))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                VStack (alignment: .leading){
                                    HStack(alignment: .bottom) {
                                        Text("Monday")
                                            .modifier(CustomTextModifier(size: 25, color: .white))
                                            .bold()
                                        
                                        Text("in Hayward, CA")
                                            .modifier(CustomTextModifier(size: 12, color: .white))
                                            .italic()
                                            .padding(.top, -18)
                                    }
                                    
                                    HStack {
                                        Text("October 20, 2024")
                                            .modifier(CustomTextModifier(size: 15, color: .white))
                                            .bold()
                                        
                                        Text("@3:00pm")
                                            .modifier(CustomTextModifier(size: 12, color: .white))
                                            .padding(.bottom, -3)
                                    }
                                }
                                
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "dollarsign")
                                        .padding(.trailing, -8)
                                        .modifier(CustomTextModifier(size: 18, color: .green))
                                        .bold()
                                    
                                    Text(\(currentPrice))
                                        .modifier(CustomTextModifier(size: 20, color: .green))
                                        .bold()
                                }
                                
                            }
                            .padding(.top, -8)
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .background(
                            NavigationLink("",
                                           destination: BookAppointmentView().navigationBarBackButtonHidden(true))
                            
                            .opacity(0)
                        )
                    }
                    else{
                        Text("No current apponitments")
                            .font(.system(size: 15))
                            .italic()
                    }
                
                    //Book new appointment button
                    //DESTINATION: BookingAppointment_page, BookingAppointmentView
                    HStack{
                        Image(systemName: "plus")
                            .modifier(CustomTextModifier(size: 20, color: .blue))
                            .bold()
                        
                        Text("Book new appointment")
                            .modifier(CustomTextModifier(size: 15, color: .blue))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(
                        NavigationLink("", destination: BookAppointmentView().navigationBarBackButtonHidden(true))
                            .opacity(0)
                    )
                    .frame(maxWidth: .infinity, maxHeight: 15, alignment: .center)
                    
                    
                    if appointment_isBooked {
                        
                        //View all appointments Button
                        //DESTINATION: none
                        HStack{
                            Image(systemName: "list.dash")
                                .modifier(CustomTextModifier(size: 16, color: .blue))
                                .bold()
                                .padding(.leading, 2)
                            
                            Text("View all appointments")
                                .modifier(CustomTextModifier(size: 15, color: .blue))
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(
                            NavigationLink("", destination: BookAppointmentView().navigationBarBackButtonHidden(true))
                                .opacity(0)
                        )
                        .frame(maxWidth: .infinity, maxHeight: 15, alignment: .center)
                    }
                }header:{
                    Text("Appointments")
                        .foregroundColor(.white)
                }
//                .listSectionSpacing(0)
                
                
                
                
            //Section from "APOINTMENTS" to "View all appointments" Button
                Section{
                    VStack(alignment: .leading){
                        
                        //Most recent haircut
                        Text("Most recent appointment")
                            .modifier(CustomTextModifier(size: 13, color: .white))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            HStack {
                                Text("Feb 3, 2024")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20)).bold()
                                
                                Spacer()
                                
                                Text("2:45pm")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17)).bold()
                            }
                            
                            
                            Text("Elk Grove, CA")
                                .modifier(CustomTextModifier(size: 11, color: .gray))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                .italic()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    //List of fake barber appointments
                    ForEach(0...3, id: \.self){ _ in
                        VStack(alignment: .leading){
                            
                            //List item of barber appointment
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Mar 20, 2023")
                                            .modifier(CustomTextModifier(size: 15, color: .white))
                                            .bold()
                                    }
                                    
                                    Text("Hayward, CA")
                                        .modifier(CustomTextModifier(size: 11, color: .gray))
                                        .italic()
                                }
                                .padding(.leading, 5)
                                
                                Spacer()
                                
                                HStack {
                                    Text("4:45pm")
                                        .modifier(CustomTextModifier(size: 15, color: .white))
                                        .bold()
                                }
                                
                                
                            }
                        }
                        .frame(maxHeight: 60)
                    }.listRowInsets(.init(top: 10, leading: 15, bottom: 10, trailing: 15))
                    
                    
                    
                    //Show full history button
                    HStack{
                        Image(systemName: "calendar")
                            .modifier(CustomTextModifier(size: 20, color: .blue))
                        
                        Text("Show full history")
                            .modifier(CustomTextModifier(size: 17, color: .blue))
                            .bold()
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    
                } header: {
                    Text("History")
                        .foregroundColor(.white)
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
            .edgesIgnoringSafeArea(.bottom)

            // fetch the  current price from the dynamoDB
            .onAppear {
                fetchCurrentPrice()
            }
            .onTapGesture {
                if showAppointment && !showCancel_Bool{
                    withAnimation{
                        self.detailHeight = 400.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showAppointment.toggle()
                            disabledButtons.toggle()
                            selected = ""
                            
                            // Put any code you want to be delayed here
                        }
                    }
                }
            }
            
        }
    }
    
    
    
    
}


//Show page on canvas simulator
struct client_Preview: PreviewProvider {
    static var previews: some View {
        clientView()
    }
}


/* APPLICATION CHECKLIST
 - Finish "Book new appointment" Button
 - Create page for "View all appointments" Button
 - Create page for "Show full history" Button
 */
