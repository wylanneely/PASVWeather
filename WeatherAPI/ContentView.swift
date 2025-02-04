//
//  ContentView.swift
//  WeatherAPI
//
//  Created by Wylan L Neely on 1/25/25.
//

import SwiftUI

struct WeatherRow: View {
    
    let city: String
    
    @State private var weatherData: WeatherObject? = nil
    
     
    var body: some View {
        HStack {
            VStack{
                Text(weatherData?.cityName ?? city)
                    .font(Font.custom("Poppins-SemiBold", size: 20))
                
                Text(weatherData?.tempFahrenheit?.asDisplayString() ?? "" + "°F")
                    .font(Font.custom("Poppins-SemiBold", size: 60))
            }
            Spacer()
            AsyncImage(url: weatherData?.iconURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .scaledToFill()
                        .frame(maxWidth: 90, maxHeight: 90)
                case .failure:
                    Image(systemName: "cloud.fill")
                        .scaledToFit()
                        .frame(maxWidth: 90, maxHeight: 90)
                        .foregroundColor(.red)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        Task {
            do {
                // Fetch weather data
                let fetchedWeatherObject = try await NetworkController.fetchWeatherData(city)
                await MainActor.run {
                    
                    weatherData = fetchedWeatherObject
                }
            } catch {
                await MainActor.run {
                }
            }
        }
    }
}

struct ContentView: View {
    
    @State private var searchText = ""
    @State private var weatherObject: WeatherObject? = nil
    
  //  @State private var persistedCities: [String]?
  //  @State private var showPersistedCities: Bool = false
    
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search Location", text: $searchText, onEditingChanged: { isEditing in
                    if isEditing {
                        //                        loadPersistedCities()
                        //                        showPersistedCities = !(persistedCities?.isEmpty ?? true)
                        //                            } else {
                        //                        showPersistedCities = false
                    }
                })
                .textFieldStyle(.automatic)
                .padding(.leading)
                .font(Font.custom("Poppins-Regular", size: 16))
                //                .onChange(of: searchText) { newValue in
                //                    showPersistedCities = !newValue.isEmpty && !(persistedCities?.isEmpty ?? true)
                //                }
                
                
                Button(action: {
                    fetchWeather(for: searchText)
                }) {
                    Label("Search", systemImage: "magnifyingglass")
                        .labelStyle(.iconOnly)
                        .padding()
                        .foregroundColor(Color.gray.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding(.trailing,5.0)
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16)
            .padding(.horizontal, 20.0)
            .padding(.top, 10)
        }
    }
        
        //        if showPersistedCities, let cities = persistedCities {
        //                List(cities, id: \.self) { city in
        //                    WeatherRow(city: city)
        //                        .padding()
        //                        .background(
        //                            RoundedRectangle(cornerRadius: 15)
        //                                        .fill(Color(hex: "#F2F2F2"))
        //                                        .shadow(color: .gray.opacity(0.2),
        //                                                radius: 5,
        //                                                x: 0, y: 3)
        //                        )
        //                        .overlay {
        //                            Button(action: {
        //                                searchText = city
        //                                showPersistedCities = false
        //                                fetchWeather(for: city)}) {}
        //                            }
        //                        .listRowInsets(EdgeInsets())
        //                        .listRowSeparator(.hidden)
        //                        .listRowBackground(Color.clear)
        //                        .padding(.vertical, 10)
        //                        .padding(.horizontal, 10)
        //                }
        //                .listStyle(.plain)
        //                .padding(.horizontal)
        //                .frame(maxWidth: .infinity,maxHeight: .infinity)
        //                .background(Color.white)
        //        }
        //
        //        if !showPersistedCities {
        //            Group {
        //                // Weather Info or Loading State
        //                if isLoading {
        //                    ProgressView("Fetching weather...")
        //                        .padding()
        //                } else if let weather = weatherObject {
        //
        //                    WeatherView(weather: weather)
        //
        //                } else if let error = errorMessage {
        //                    Text(error)
        //                        .foregroundColor(.red)
        //                        .padding()
        //                } else {
        //                    VStack{
        //                        Text("No City Selected")
        //                            .font(Font.custom("Poppins-SemiBold", size: 30))
        //                            .padding(.bottom, 1.0)
        //                        Text("Please Search for a city")
        //                            .font(Font.custom("Poppins-Regular", size: 15))
        //                    }
        //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
        //                }
        //
        //                Spacer()
        //            }
    
        
    
    private func fetchWeather(for city: String) {
        guard !city.isEmpty else {
            errorMessage = "Enter city name."
            return
        }
        
        isLoading = true
        //weatherObject = nil
        errorMessage = nil
        
        Task {
            do {
                // Fetch weather data
                let fetchedWeatherObject = try await NetworkController.fetchWeatherData(city)
                
                await MainActor.run {
                    
                    
                    weatherObject = fetchedWeatherObject
                  //  saveCity(weatherObject?.cityName ?? city)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
    
    //MARK: Persistance
    
//    private func saveCity(_ city: String) {
//           var cities = UserDefaults.standard.stringArray(forKey: "persistedCities") ?? []
//           if !cities.contains(city) {
//               cities.append(city)
//               UserDefaults.standard.set(cities, forKey: "persistedCities")
//           }
//       }
//       
//       private func loadPersistedCities() {
//           persistedCities = UserDefaults.standard.stringArray(forKey: "persistedCities") ?? []
//       }
}

struct WeatherView: View {
    let weather : WeatherObject
    
    var body: some View {
        AsyncImage(url: weather.iconURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                VStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 140, maxHeight: 140)
                        .padding(.bottom, 10.0)
                    Text(weather.cityName ?? "add error handling for currupted data")
                        .font(Font.custom("Poppins-SemiBold", size: 30))
                    HStack {
                        Text((weather.tempFahrenheit?.asDisplayString() ?? ""))
                            .font(Font.custom("Poppins-SemiBold", size: 70))
                        Text("°")
                            .font(Font.custom("Poppins-Regular", size: 20))
                            .offset(y: -20)
                    }
                    HStack {
                        VStack{
                            Text("Humidity")
                                .font(Font.custom("Poppins-Regular", size: 12))
                                .foregroundColor(Color(hex: "#C4C4C4"))
                                .padding(.top, 20)

                            Text((weather.humidity?.asDisplayString() ?? "") + "%")
                                .font(Font.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(Color(hex: "#9A9A9A"))
                                .padding(.bottom, 20)

                        }
                        .padding(.horizontal, 20)
                        VStack{
                            Text("UV")
                                .font(Font.custom("Poppins-Regular", size: 12))
                                .foregroundColor(Color(hex: "#C4C4C4"))
                                .padding(.top, 20)

                            Text(weather.uv?.asDisplayString() ?? "")
                                .font(Font.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(Color(hex: "#9A9A9A"))
                                .padding(.bottom, 20)

                        }
                        .padding(.horizontal, 20)
                        VStack{
                            Text("Feels Like")
                                .font(Font.custom("Poppins-Regular", size: 10))
                                .foregroundColor(Color(hex: "#C4C4C4"))
                                .padding(.top, 20)

                            Text((weather.feelsLikeF?.asDisplayString() ?? "") + "°")
                                .font(Font.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(Color(hex: "#9A9A9A"))
                                .padding(.bottom, 20)

                        }
                        .padding(.horizontal, 20)

                    }
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(15)
                    .padding(20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)


            case .failure:
                Image(systemName: "cloud.fill") // Fallback image in case of failure
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundColor(.gray) // Optional: Add a tint to the fallback image
            @unknown default:
                EmptyView()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
