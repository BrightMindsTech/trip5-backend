import SwiftUI
import MapKit

struct MapLocationPicker: View {
    let title: String
    @Binding var selectedLocation: LocationInfo?
    @Binding var addressText: String
    let locationService: LocationService
    
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.5565, longitude: 35.8467),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    ))
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isGeocoding = false
    @State private var awaitingMyLocation = false
    
    private let completer = MKLocalSearchCompleter()
    @State private var completions: [MKLocalSearchCompletion] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(L10n.searchAddress, text: $searchText)
                    .textFieldStyle(.plain)
                    .onChange(of: searchText) { _, newValue in
                        searchAddress(newValue)
                    }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button {
                awaitingMyLocation = true
                isGeocoding = true
                locationService.requestLocation()
            } label: {
                HStack {
                    if isGeocoding {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "location.fill")
                    }
                    Text(L10n.useMyLocation)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isGeocoding)
            .onChange(of: locationService.currentLocation) { _, newLoc in
                guard awaitingMyLocation, let loc = newLoc else { return }
                awaitingMyLocation = false
                isGeocoding = false
                let coord = loc.coordinate
                position = .region(MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
                Task {
                    let addr = await locationService.reverseGeocode(coordinate: coord)
                    if let addr = addr {
                        selectedLocation = LocationInfo(coordinate: coord, address: addr)
                        addressText = addr
                        searchText = addr
                    }
                }
            }
            
            ZStack(alignment: .bottom) {
                MapReader { proxy in
                    Map(position: $position, interactionModes: .all) {
                        if let loc = selectedLocation {
                            Annotation("", coordinate: loc.coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .mapStyle(.standard)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture { screenPoint in
                        if let coord = proxy.convert(screenPoint, from: .local) {
                            handleMapTap(at: coord)
                        }
                    }
                }
                
                if !searchResults.isEmpty {
                    VStack {
                        ForEach(searchResults.prefix(5), id: \.self) { item in
                            Button {
                                selectSearchResult(item)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name ?? "")
                                            .font(.subheadline.weight(.medium))
                                        Text(item.placemark.title ?? "")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(8)
                                .background(Color(.systemBackground))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
                }
            }
            
            if let loc = selectedLocation {
                Text(loc.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
    }
    
    private func handleMapTap(at coordinate: CLLocationCoordinate2D) {
        Task {
            let addr = await locationService.reverseGeocode(coordinate: coordinate)
            let address = addr ?? "\(coordinate.latitude), \(coordinate.longitude)"
            selectedLocation = LocationInfo(coordinate: coordinate, address: address)
            addressText = address
            searchText = address
            position = .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
    
    private func searchAddress(_ query: String) {
        guard query.count >= 3 else {
            searchResults = []
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 32.5565, longitude: 35.8467),
            span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        )
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            Task { @MainActor in
                searchResults = response?.mapItems ?? []
            }
        }
    }
    
    private func selectSearchResult(_ item: MKMapItem) {
        let coord = item.placemark.coordinate
        let addr = item.placemark.compactAddress ?? "\(coord.latitude), \(coord.longitude)"
        selectedLocation = LocationInfo(coordinate: coord, address: addr)
        addressText = addr
        searchText = addr
        searchResults = []
        position = .region(MKCoordinateRegion(
            center: coord,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
}

private extension MKPlacemark {
    var compactAddress: String? {
        [thoroughfare, locality, administrativeArea].compactMap { $0 }.joined(separator: ", ")
    }
}
