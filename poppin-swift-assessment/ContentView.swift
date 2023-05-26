////
////  ContentView.swift
////  poppin-swift-assessment
////
////  Created by Tej Thambi on 5/25/23.
////
//

import SwiftUI

struct ContentView: View {
    @State private var parties: [Party] = []
    @State private var searchText = ""
    
    var filteredParties: [Party] {
        if searchText.isEmpty {
            return parties
        } else {
            return parties.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack {
            Text("Boppin'")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.gold)
            
            SearchBar(text: $searchText)
            
            PartyListView(parties: filteredParties)
                .background(Color.black)
            
            Button(action: addRandomParty) {
                Text("Create Party!")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.gold)
                    .background(Color.black)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gold, lineWidth: 2)
                    )
            }
            .padding()
            
        }
        .background(Color.black)
        .onAppear {
            generateInitialParties()
        }
    }
    
    private func generateInitialParties() {
        for _ in 1...3 {
            addRandomParty()
        }
    }
    
    private func addRandomParty() {
        let name = getRandomPartyName()
        let bannerImage = getRandomBannerImage()
        let price = getRandomPrice()
        let startDate = getRandomStartDate()
        let endDate = getRandomEndDate()
        
        let party = Party(name: name, bannerImage: bannerImage, price: price, startDate: startDate, endDate: endDate)
        
        parties.insert(party, at:0)
    }
    
    private func getRandomPartyName() -> String {
        let randomIndex = Int.random(in: 0...9)
        let name = partyNames[randomIndex]
        return name
    }
    
    private func getRandomBannerImage() -> Image {
        let randomIndex = Int.random(in: 0...9)
        let image = partyImages[randomIndex]
        return image
    }
    
    private func getRandomPrice() -> Double {
        let randomValue = Double.random(in: 5.0...30.0)
        let roundedValue = round(randomValue * 2) / 2
        return roundedValue
    }
    
    private func getRandomStartDate() -> Date {
        let currentDate = Date()
        let daysToAdd = Int.random(in: 1...7)
        return Calendar.current.date(byAdding: .day, value: daysToAdd, to: currentDate) ?? currentDate
    }
    
    private func getRandomEndDate() -> Date? {
        let hasEndDate = Double.random(in: 0...1) < 0.5
        if hasEndDate {
            let currentDate = Date()
            let daysToAdd = Int.random(in: 8...14)
            return Calendar.current.date(byAdding: .day, value: daysToAdd, to: currentDate)
        } else {
            return nil
        }
    }
}

struct PartyListView: View {
    var parties: [Party]

    var body: some View {
        List(parties) { party in
            PartyCardView(party: party)
        }
        .background(Color.black)
    }
}

struct PartyCardView: View {
    let party: Party

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(party.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gold)
            
            party.bannerImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(10)
            
            Text("Price: $\(String(format: "%.2f", party.price))")
                .font(.headline)
                .foregroundColor(.gold)
            
            Text("Start Date: \(formatDate(party.startDate))")
                .font(.subheadline)
                .foregroundColor(.gold)
            
            if let endDate = party.endDate {
                Text("End Date: \(formatDate(endDate))")
                    .font(.subheadline)
                    .foregroundColor(.gold)
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .opacity(text.isEmpty ? 0 : 1)
        }
        .padding(.horizontal)
    }
}

extension Color {
    static let gold = Color("GoldColor")
}

struct Party: Identifiable {
    let id = UUID()
    let name: String
    let bannerImage: Image
    let price: Double
    let startDate: Date
    let endDate: Date?
}

func generatePartyImages() -> [Image] {
    var partyImages: [Image] = []
    for index in 1...10 {
        let imageName = "Party\(index)"
        let image = Image(imageName)
        partyImages.append(image)
    }
    return partyImages
}

let partyImages = generatePartyImages()
let partyNames = ["Wild Wild West", "Stoplight", "80s", "Mansion Party", "Neon", "Foam party", "Tropical", "Outer Space", "Under the Sea", "Masquerade"]

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
