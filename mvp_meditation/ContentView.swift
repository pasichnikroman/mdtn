import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var heartRate: Double = 0
    @State private var isAuthorized = false
    @State private var isFetching = false
    @State private var statusMessage: String = "Requesting authorization..."

    var body: some View {
        VStack {
            Text("Hello World!")
                .font(.largeTitle)
                .padding()

            Text("Heart Rate: \(heartRate, specifier: "%.0f") BPM")
                .font(.largeTitle)
                .padding()

            Text(statusMessage)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()

            if isFetching {
                ProgressView("Fetching heart rate data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .onAppear {
            requestAuthorization()
        }
    }

    func requestAuthorization() {
        let healthKitStore = HKHealthStore()
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            statusMessage = "Heart rate data is not available."
            return
        }

        healthKitStore.requestAuthorization(toShare: [], read: [heartRateType]) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    isAuthorized = true
                    statusMessage = "Authorization granted. Fetching heart rate data..."
                    fetchHeartRateData()
                }
            } else {
                if let error = error {
                    statusMessage = "Authorization failed: \(error.localizedDescription)"
                } else {
                    statusMessage = "Authorization denied."
                }
            }
        }
    }

    func fetchHeartRateData() {
        guard isAuthorized else {
            statusMessage = "Not authorized to access heart rate data."
            return
        }

        isFetching = true

        let healthKitStore = HKHealthStore()
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: 1) { (query, samples, deletedObjects, newAnchor, error) in
            isFetching = false

            if let heartRateSample = samples?.first as? HKQuantitySample {
                let heartRateValue = heartRateSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                DispatchQueue.main.async {
                    self.heartRate = heartRateValue
                    statusMessage = "Heart rate data fetched successfully."
                }
            } else {
                DispatchQueue.main.async {
                    statusMessage = "No heart rate data available."
                }
            }
        }
        healthKitStore.execute(query)
    }
}
