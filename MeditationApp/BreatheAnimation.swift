//
//  BreatheAnimation.swift
//  MeditationApp
//
//  Created by Alisa Serhiienko on 05.04.2024.
//

import SwiftUI

struct BreatheAnimation: View {
    
    @State var breathePractice = "Breathe In"
    @State var breathing = false
    @State var startBreathing = false
    @State var timerCount: CGFloat = 0
    
    let flowerCircles: [_Circle] = [
        .init(color: Color(red: 23/255, green: 165/255, blue: 163/255)),
        .init(color: Color(red: 235/255, green: 96/255, blue: 145/255)),
        .init(color: Color(red: 242/255, green: 167/255, blue: 190/255)),
        .init(color: Color(red: 154/255, green: 225/255, blue: 225/255)),
        .init(color: Color(red: 23/255, green: 165/255, blue: 163/255)),
        .init(color: Color(red: 185/255, green: 225/255, blue: 235/255)),
        .init(color: Color(red: 242/255, green: 167/255, blue: 190/255)),
        .init(color: Color(red: 154/255, green: 225/255, blue: 225/255))
    ]
    

    
    
    struct _Circle: Hashable {
        let color: Color
    }
   
    
    var body: some View {
        ZStack {
            
            Color(red: 252/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()
            
            meditationView()
            
            Text(breathePractice)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 64)
                .opacity(breathing ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: breathePractice)
                .animation(.easeInOut(duration: 1), value: breathing)
            
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if breathing {
                if timerCount >= 3 {
                    timerCount = 0
                   breathePractice = (breathePractice == "Breathe Out" ? "Breathe In" : "Breathe Out")
                    withAnimation(.easeInOut(duration: 2.5).delay(0.02)) {
                        startBreathing.toggle()
                    }
                } else {
                    timerCount += 0.01
                }
            } else {
                timerCount = 0
            }
        }
    }
    
    @ViewBuilder
    func meditationView() -> some View {
        VStack {
            GeometryReader(content: { proxy in
                let size = proxy.size
                VStack(alignment:.center) {
    
                    Spacer()
                    breathingFlower(size: size)
                        .padding(.bottom, 210)
           
                    Button {
                        breatheOn()
                    } label: {
                        Text(breathing ? "Finish Meditation Session" : "Start Breathing Exercise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.pink.opacity(0.65))
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)

                    }
                    .padding()
                }
                .frame(width: size.width, height: size.height, alignment: .bottom)
            })
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func breatheOn() {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
            breathing.toggle()
        }
        
        if breathing {
            withAnimation(.easeInOut(duration: 3).delay(0.06)) {
                startBreathing = true
            }
        } else {
            withAnimation(.easeInOut(duration: 1.5)) {
                startBreathing = false
            }
        }
    }
    
    @ViewBuilder
    func breathingFlower(size: CGSize) -> some View{
        
        ZStack {
            ForEach(Array(zip(flowerCircles.indices, flowerCircles)), id: \.0) { index, circle in                
                Circle()
                    .fill(circle.color.opacity(0.56))
                    .frame(width: 160, height: 160)
                    .offset(x: startBreathing ? 0 : 80)
                    .rotationEffect(.init(degrees: Double(index) * 45 ))
                    .rotationEffect(.init(degrees: startBreathing ? -45 : 0 ))

                
            }
        }
        .scaleEffect(startBreathing ? 0.25 : 1)
    }
}

#Preview {
    BreatheAnimation()
}


