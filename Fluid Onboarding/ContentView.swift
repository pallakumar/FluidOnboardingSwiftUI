//
//  ContentView.swift
//  Fluid Onboarding
//
//  Created by Palla Kumar on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OnboardingView()
    }
}

// MARK: - Liquid Swipe Shape
struct LiquidSwipeShape: Shape {
    var offset: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let curveWidth: CGFloat = max(30, abs(offset) * 0.6)
        
        // Start at top-left
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        // Curve back to top-left (liquid effect)
        let controlPoint1 = CGPoint(x: curveWidth, y: height * 0.25)
        let controlPoint2 = CGPoint(x: curveWidth, y: height * 0.75)
        path.addCurve(to: .zero,
                      control1: controlPoint1,
                      control2: controlPoint2)
        
        return path
    }
}

// MARK: - Onboarding Flow with Liquid Swipe
struct OnboardingView: View {
    @State private var dragOffset: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    // Replace colors with real onboarding pages
    let pages: [OnboardingPageView] = [
        OnboardingPageView(title: "Welcome",
                           subtitle: "Discover amazing features",
                           image: "onboard1"),
        OnboardingPageView(title: "Track",
                           subtitle: "Keep track of your progress easily",
                           image: "onboard2"),
        OnboardingPageView(title: "Get Started",
                           subtitle: "Dive in now!",
                           image: "onboard3")
    ]
    
    var body: some View {
        ZStack {
            pages[(currentIndex + 1) % pages.count] // next page
                .ignoresSafeArea()
            
            pages[currentIndex] // current page with liquid mask
                .clipShape(LiquidSwipeShape(offset: dragOffset))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = -value.translation.width
                        }
                        .onEnded { value in
                            if -value.translation.width > 150 {
                                withAnimation(.spring()) {
                                    dragOffset = -1000
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    currentIndex = (currentIndex + 1) % pages.count
                                    dragOffset = 0
                                }
                            } else {
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
        }
    }
}

// MARK: - Onboarding Page
struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let image: String

    var body: some View {
        ZStack {
            // Full screen background image
            Image(image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Overlay content
            VStack(spacing: 20) {
                Spacer()
                
                Text(title)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
                    .shadow(radius: 5)
                
                Text(subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.green.opacity(0.9))
                    .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
