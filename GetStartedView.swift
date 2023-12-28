    //
    //  GetStartedView.swift
    //  pawfectMatch
    //
    //  Created by Keya Gholap on 11/27/23.
    //

    import Foundation
    import SwiftUI
    import CoreLocation
    import MapKit


    //pet profile view
    struct GetStartedView: View {

    @State private var markers: [Location] = []  //markers array
    @State private var searchText = ""
    @State private var locationInfo: (latitude: String, longitude: String)? = nil

    // default location set to Tempe
    private static let defaultLocation = CLLocationCoordinate2D(
        latitude: 33.4255,
        longitude: -111.9400
        )
        @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: defaultLocation, // Use the default location
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

        var body: some View {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region,
                interactionModes: .all,
                annotationItems: markers
                ) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                    Circle()
                    .strokeBorder(.red, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    Text(location.name)
                    .foregroundColor(.black)
                    .bold()
                    .font(.caption)
            }
        }
    }
    .onTapGesture {print("Tapped on the map")}
    }//zstack
    .ignoresSafeArea()

    searchBar

    }//some view

    private var searchBar: some View {
        HStack {
            Button {
            // Clear existing markers
            markers.removeAll()

            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchText
            searchRequest.region = region

            MKLocalSearch(request: searchRequest).start { response, error in
            guard let response = response else {
            print("Error: \(error?.localizedDescription ?? "Unknown error").")
            return
    }

    // Add markers for each result
        markers = response.mapItems.map { item in
        Location(
        name: item.name ?? "",
        coordinate: item.placemark.coordinate
        )
        }

    // Center the map on the first result
    if let firstLocation = markers.first {
        region = MKCoordinateRegion(
        center: firstLocation.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
        }
        }
    } label: {
    Image(systemName: "location.magnifyingglass")
        .resizable()
        .foregroundColor(.accentColor)
        .frame(width: 24, height: 24)
        .padding(.trailing, 12)
    }
    TextField("Search pizza, coffee, movie...", text: $searchText)
    .foregroundColor(.accentColor)
    }
        .padding()
        .background {
        RoundedRectangle(cornerRadius: 8)
        .foregroundColor(.white)
        }
    }//search function

    }
