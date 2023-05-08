import SwiftUI
import StripePaymentSheet

struct CheckoutView: View {
    private static let backendURL = URL(string: "http://127.0.0.1:5000")!
    @State private var paymentIntentClientSecret: String?
    @State private var isPayButtonEnabled = false

    var body: some View {
        VStack {
            Spacer()
            Button(action: pay) {
                Text("Pay now")
                    .padding(12)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .disabled(!isPayButtonEnabled)
            .padding()
        }
        .onAppear {
            StripeAPI.defaultPublishableKey = "pk_test_VOOyyYjgzqdm8I3SrBqmh9qY"
            fetchPaymentIntent()
        }
    }

    private func fetchPaymentIntent() {
        let url = Self.backendURL.appendingPathComponent("/create-payment-intent")

        let shoppingCartContent: [String: Any] = [
            "items": [
                ["id": "xl-shirt"]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: shoppingCartContent)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let clientSecret = json["clientSecret"] as? String
            else {
                let message = error?.localizedDescription ?? "Failed to decode response from server."
                DispatchQueue.main.async {
                    displayAlert(title: "Error loading page", message: message)
                }
                return
            }

            print("Created PaymentIntent")
            paymentIntentClientSecret = clientSecret
            isPayButtonEnabled = true
        }.resume()
    }

    private func pay() {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return
        }

        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Example, Inc."

        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: paymentIntentClientSecret,
            configuration: configuration)

        /*paymentSheet.present(from: <#UIViewController#>) { paymentResult in
            switch paymentResult {
            case .completed:
                displayAlert(title: "Payment complete!")
            case .canceled:
                print("Payment canceled!")
            case .failed(let error):
                displayAlert(title: "Payment failed", message: error.localizedDescription)
            }
        }*/
    }

    private func displayAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}
