//
//  DayValue.swift
//  ZackApp
//
//  Created by user on 11/20/21.
//

import SwiftUI
import Foundation

var theMonth = 0

extension Date {
    static var firstDayOfWeek = Calendar.current.firstWeekday
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        //           let weekdays = calendar.shortWeekdaySymbols
        
        //           return weekdays.map { weekday in
        //               guard let firstLetter = weekday.first else { return "" }
        //               return String(firstLetter).capitalized
        //           }
        // Adjusted for the different weekday starts
        var weekdays = calendar.shortWeekdaySymbols
        if firstDayOfWeek > 1 {
            for _ in 1..<firstDayOfWeek {
                if let first = weekdays.first {
                    weekdays.append(first)
                    weekdays.removeFirst()
                }
            }
        }
        return weekdays.map { $0.capitalized }
    }
       
       static var fullMonthNames: [String] {
           let dateFormatter = DateFormatter()
           dateFormatter.locale = Locale.current

           return (1...12).compactMap { month in
               dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
               let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
               return date.map { dateFormatter.string(from: $0) }
           }
       }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
//    var sundayBeforeStart: Date {
//        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
//        let numberFromPreviousMonth = startOfMonthWeekday - 1
//        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
//    }
    
    // New to accomodate for different start of week days
    var firstWeekDayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let numberFromPreviousMonth = startOfMonthWeekday - Self.firstDayOfWeek
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        // Current month days
        for dayOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        // previous month days
        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth)
            days.append(newDay!)
        }
        
//        return days.filter { $0 >= sundayBeforeStart && $0 <= endOfMonth }.sorted(by: <)
        // Fixed to accomodate different weekday starts
        return days.filter { $0 >= firstWeekDayBeforeStart && $0 <= endOfMonth }.sorted(by: <)
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

struct client: Identifiable{
    var id = UUID().uuidString
    var name: String
    var email: String
    var phone_number: String
    var password: String
    var join_city: String
    
    var join_date: String
    
    var completed_appointments: Int
    var missed_appointments: Int
    var cancelled_appointments: Int
}
//
//
class dataPort: ObservableObject{
    @Published var clients: [client] = []
}

struct DatePickerButtonView: View {
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            Button(action: {
                showDatePicker.toggle()
            }) {
                Text("Select Date")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if showDatePicker {
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            }
            
            Text("Selected Date: \(selectedDate, style: .date)")
                .padding()
        }
        .padding()
    }
}


struct ImageAndText: View {
    var text: String
    var image: String
    var size: CGFloat
    var textColor: Color = .white
    var imageColor: Color = .white
    var rectColor: Color = .blue
    var bold: Bool = false
    var rect: Bool = false
    
    
    var body: some View{
        HStack{
            Image(systemName: image)
                .modifier(CustomTextModifier(size: size-2, color: imageColor))
                .if(bold) { view in
                    view
                        .bold()
                }
        
            Text("\(text)")
                .modifier(CustomTextModifier(size: size, color: textColor))
                .if(bold) { view in
                    view
                        .bold()
                }
        }
        .if(rect){view in
            view
                .padding(10)
                .background(rectColor)
                .cornerRadius(10)
        }
    }
}


struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

func extraDate(date: Date)->[String]{
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY MMMM"
    let date = formatter.string(from: date)
    return date.components(separatedBy: " ")
}


func formatDate(date: Date, format: String)->[String]{
    let formatter = DateFormatter()
    formatter.dateFormat = format
    let date = formatter.string(from: date)
    return date.components(separatedBy: " ")
}

func compDate(date: Date)->String{
    let format = DateFormatter()
    format.dateFormat = "MMMM d, YYYY"
    let date = format.string(from: date)
    return date
}

func getSampleDate(offset: Int)->Date{
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}

func extractDate()->[DateValue]{
    let calendar = Calendar.current
    let currentMonth = getCurrentMonth()
    
    var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
        let day = calendar.component(.day, from: date)
        return DateValue(day: day, date: date)
    }
    
    let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
    
    for _ in 0..<firstWeekday - 1{
        days.insert(DateValue(day: -1, date: Date()), at: 0)
    }
    return days
}

func getCurrentMonth()->Date{
    let calendar = Calendar.current
    
    //    guard let theMonth = calendar.date(byAdding: .month, value: self.theMonth, to: Date()) else{
    guard let theMonth = calendar.date(byAdding: .month, value: theMonth, to: Date()) else{
        return Date()
    }
    
    return  theMonth
}


struct Gri: Identifiable {
    var id = UUID().uuidString
    var name: String
    var time: String
    var merid: String
    var loc: String = "Hayward"
}






class GridViewMode: ObservableObject{
    @Published var griItems = [
        Gri(name: "John Madden", time: "3:00", merid: "AM"),
        Gri(name: "Philip Moore", time: "3:30", merid: "AM"),
        Gri(name: "Undekai Robun", time: "5:30", merid: "AM"),
        Gri(name: "John Madden", time: "3:00", merid: "PM"),
        Gri(name: "Philip Moore", time: "3:30", merid: "PM"),
        Gri(name: "Undekai Robun", time: "5:30", merid: "PM")
    ]
    @Published var currentGri: Gri?
}





struct DropViewDelegat: DropDelegate {
    
    var grid: Gri
    var gridData: GridViewMode
    
    func performDrop(info: DropInfo) -> Bool {
        ///To never disappear drag item when dropped outside
        //gridData.currentGrid = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        
        let fromIndex = gridData.griItems.firstIndex { (grid) -> Bool in
            return grid.id == gridData.currentGri?.id
        } ?? 0
        
        let toIndex = gridData.griItems.firstIndex { (grid) -> Bool in
            return grid.id == self.grid.id
        } ?? 0
        
        if fromIndex != toIndex{
            withAnimation(.default){
                let fromGrid = gridData.griItems[fromIndex]
                gridData.griItems[fromIndex] = gridData.griItems[toIndex]
                gridData.griItems[toIndex] = fromGrid
            }
        }
    }
    
    // setting Action as Move...
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
}




class FadeScrollView: UIScrollView, UIScrollViewDelegate {
    let fadePercentage: Double = 0.2
    let gradientLayer = CAGradientLayer()
    let transparentColor = UIColor.clear.cgColor
    let opaqueColor = UIColor.black.cgColor
    
    var topOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y
        
        let alpha:CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset <= 0) ? 1 : 0
        
        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
    
    var bottomOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y
        
        let alpha:CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset + scrollViewHeight >= scrollContentSizeHeight) ? 1 : 0
        
        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
        gradientLayer.locations = [0, NSNumber(floatLiteral: fadePercentage), NSNumber(floatLiteral: 1 - fadePercentage), 1]
        maskLayer.addSublayer(gradientLayer)
        
        self.layer.mask = maskLayer
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
    }
    
}


struct CustomTextModifier: ViewModifier {
    var size: CGFloat
    var color: Color = .white
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .foregroundColor(color)
            .scaledToFill()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}




extension Date{
    func getAllDates() ->[Date]{
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        //        range.removeLast()
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day-1, to: startDate)!
        }
    }
    
}

extension View{
    func fadeOutTop(fadeLength: CGFloat=50) -> some View{
        return mask(
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(
                    colors: [Color.black.opacity(0), Color.black]),
                               startPoint: .top, endPoint: .bottom
                )
                .frame(height: fadeLength)
                
                Rectangle().fill(Color.black)
                
                //                LinearGradient(gradient: Gradient(
                //                    colors: [Color.black, Color.black.opacity(0)]),
                //                               startPoint: .top, endPoint: .bottom
                //                )
                //                .frame(width: fadeLength)
            }
        )
    }
    
    func customStyle(size: CGFloat, color: Color) -> some View{
        self.font(.system(size: size))
            .foregroundColor(color)
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, modify: (Self) -> Content) -> some View {
        if condition {
            modify(self)
        } else {
            self
        }
    }
}



 
extension String {
    func formatPhoneNumber() -> String {
        let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var startIndex = cleanNumber.startIndex
        var endIndex = cleanNumber.endIndex
        
        for char in mask where startIndex < endIndex {
            if char == "X" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }
        
        return result
    }
}

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
    
}

var lightblue = Color(red:134/255, green: 171/255, blue: 247/255)
var lightblue2 = UIColor(red:134/255, green: 171/255, blue: 247/255, alpha: 1)
//var amColor = Color(red:134/255, green: 171/255, blue: 247/255)
//var pmColor = Color(red:134/255, green: 171/255, blue: 247/255)


struct AppointmentData: Identifiable{
    var id = UUID().uuidString
    var date: Date
    var time: String
    var price: Int
    var booked: Date = getSampleDate(offset: -3)
    var location = "Elk Grove Location"
}

var appData: [AppointmentData] = [
    AppointmentData(date: getSampleDate(offset: -3), time: "5:30 PM", price: 25),
    AppointmentData(date: getSampleDate(offset: -7), time: "7:00 PM", price: 35),
    AppointmentData(date: getSampleDate(offset: -12), time: "9:00 AM", price: 25)
]


struct clientData: Identifiable, Hashable{
    var id = UUID().uuidString
    var name: String = ""
    var username: String = ""
    var made: Int = 0
    var missed: Int = 0
    let joined = getSampleDate(offset: -3)
    let email = "something@verified.com"
    let number = "(916)879 - 7689"
    let joinLocation = "Sacramento CA"
}


//Model data for confirmed Clients
class ClientArrayModel: ObservableObject {
    @Published var clientArray: [clientData] = [
        clientData(name: "John Madden", username: "JMad4", made: 3, missed: 7),
        clientData(name: "Philip Moore", username: "PMoore", made: 43, missed: 17),
        clientData(name: "Kyle Alex ClydeDrexler", username: "Kyle_Drex", made: 13, missed: 7),
        clientData(name: "Emwantaiwi Iyasere", username: "ZackxIyas", made: 321, missed: 7),
        clientData(name: "John Madden", username: "JMad4", made: 0, missed: 0),
        clientData(name: "John Madden", username: "JMad4", made: 3, missed: 7),
        clientData(name: "Philip Moore", username: "PMoore", made: 43, missed: 17),
//        clientData(name: "Kyle Alex ClydeDrexler", username: "Kyle_Drex", made: 13, missed: 7),
//        clientData(name: "Emwantaiwi Iyasere", username: "ZackxIyas", made: 321, missed: 7),
//        clientData(name: "John Madden", username: "JMad4", made: 0, missed: 0),
//        clientData(name: "John Madden", username: "JMad4", made: 3, missed: 7),
//        clientData(name: "Philip Moore", username: "PMoore", made: 43, missed: 17),
//        clientData(name: "Kyle Alex ClydeDrexler", username: "Kyle_Drex", made: 13, missed: 7),
//        clientData(name: "Emwantaiwi Iyasere", username: "ZackxIyas", made: 321, missed: 7),
//        clientData(name: "John Madden", username: "JMad4", made: 0, missed: 0)
    ]
}

//Model data for Pending clients
class PendingArrayModel: ObservableObject {
    @Published var pendingArray: [clientData] = [
        clientData(name: "John Madden", username: "JMad4", made: 3, missed: 7),
        clientData(name: "Philip Moore", username: "PMoore", made: 43, missed: 17),
        clientData(name: "Kyle Alex ClydeDrexler", username: "Kyle_Drex", made: 13, missed: 7),
        clientData(name: "Emwantaiwi Iyasere", username: "ZackxIyas", made: 321, missed: 7),
        clientData(name: "John Madden", username: "JMad4", made: 0, missed: 0)//,
//        clientData(name: "John Madden", username: "JMad4", made: 3, missed: 7),
//        clientData(name: "Philip Moore", username: "PMoore", made: 43, missed: 17),
//        clientData(name: "Kyle Alex ClydeDrexler", username: "Kyle_Drex", made: 13, missed: 7),
//        clientData(name: "Emwantaiwi Iyasere", username: "ZackxIyas", made: 321, missed: 7),
//        clientData(name: "John Madden", username: "JMad4", made: 0, missed: 0),
//        clientData(name: "John Madden", username: "JMad4", made: 3, missed: 7),
//        clientData(name: "Philip Moore", username: "PMoore", made: 43, missed: 17),
//        clientData(name: "Kyle Alex ClydeDrexler", username: "Kyle_Drex", made: 13, missed: 7),
//        clientData(name: "Emwantaiwi Iyasere", username: "ZackxIyas", made: 321, missed: 7),
//        clientData(name: "John Madden", username: "JMad4", made: 0, missed: 0)
    ]
}

// MARK: Swipe Trigger Functions (Temporary placeholder for backend call)

// Placeholder function to simulate updating price
func updatePrice (_ newPrice: Int) {
    print("Swipe action triggereed. Intended to update price to : \(newPrice)")
    // TODO: Replace with API call to update price in DynamoDB

    // TODO: Update to the actually API URL to update the database.
    guard let url = URL(string: "https://your-api-url.com/update-price") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Tell the server side I'm sending JSON
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = ["price": newPrice]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Failed to update price: \(error.localizedDescription)")
            return
        }

        print("Successfully triggered backend to update price: \(newPrice)")

    }.resume()
}





