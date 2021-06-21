//
//  ContentView.swift
//  20210608
//
//  Created by 岡部 紅有 on 2021/06/08.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var selectedTag = 1
    
    var body: some View {
        TabView(selection: $selectedTag) {
            HomeTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("HOME")
                }.tag(1)
            CalenderTabView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("カレンダー")
                }.tag(2)
            PieChartTabView()
                .tabItem {
                    Image("waveform.path.ecg.rectangle")
                    Text("グラフ")
                }.tag(3)
            
        }
    }
}


struct HomeTabView: View {
    @State var isShow: Bool = false
    
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Button(action: {
                        isShow = true
                    }) {
                        Text("追加")
                    }
                    .sheet(isPresented: $isShow) {
                        SomeView(isPresented: $isShow)
                    }
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.black)
                    }
                }
                
                Text("目標")
                    .fontWeight(.bold)
                
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .overlay(Rectangle().stroke(Color.black.opacity(0.05), lineWidth: 2))
            
            Spacer()
            
            List {
                Text("あああ")
            
            }
        
        }
       
    }

}

struct SomeView: View{
    @Binding var isPresented: Bool
    var komoku = ["食費", "外食費", "日用品", "交通費", "その他"]
    @State var mokuhyo = ""
    @State var selected = 0
    @State var date = Date()

    var body:some View{
        NavigationView {
            VStack {

                NavigationView {
                    Form {
                        TextField("金額", text: $mokuhyo)


                        DatePicker(selection: $date,
                                   label: {Text("日付")})

                        Picker(selection: $selected,
                               label: Text("カテゴリー")) {
                            ForEach(0..<komoku.count) {
                                Text(self.komoku[$0])
                            }
                        }
                    }
                    .navigationBarTitle("入力画面")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    //閉じるボタン
                    Button{
                        isPresented = false
                    } label: {
                        Text("確定")
                    }
                }
            }
        }
    }
}



struct CalenderTabView: View {
    var body: some View {
        VStack{
            Image(systemName: "calendar")
                .scaleEffect(x:3.0, y:3.0)
                .frame(width: 100, height: 100)
            Text("カレンダー").font(.system(size: 20))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.6, green: 0.6, blue: 1.0))
        .ignoresSafeArea()
    }
}



struct PieChartTabView: View{
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Button(action: {
                        
                    }) {
                        Text("追加")
//                        Image(systemName: "line.horizontal.3")
//                            .resizable()
//                            .frame(width: 20, height: 15)
//                            .foregroundColor(.black)
                    }
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.black)
                    }
                }
                
                Text("My Money")
                    .fontWeight(.bold)
                
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .overlay(Rectangle().stroke(Color.black.opacity(0.05), lineWidth: 2))
            
            //now were going to create pie chart
            
            
            GeometryReader{g in
                ZStack{
                    ForEach(0..<data.count){i in
                        
                        DrawShape(center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i)
                    }
                }
            }
            .frame(height:300)
            .padding(.top, 20)
            //since it is in circle shape so were going to clip it in circle...
            .clipShape(Circle())
            .shadow(radius: 8)
            
            //since radius is 180 so circle size will 360....
            
            VStack{
                
                ForEach(data){i in
                    
                    HStack{
                        
                        Text(i.name)
                            .frame(width: 100)
                        
                        //fixed width...
                        
                        GeometryReader{g in
                            
                            HStack{
                                
                                Spacer(minLength: 0)
                                
                                Rectangle()
                                    .fill(i.color)
                                    .frame(width: self.getWidth(width: g.frame(in: .global).width, value: i.percent), height: 10)
                                
                                Text(String(format: "\(i.percent)", "%.of"))
                                    .fontWeight(.bold)
                                    .padding(.leading, 10)
                            }
                        }
                    }
                    .padding(.top, 18)
                }
            }
            .padding()
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
    func getWidth(width: CGFloat,value : CGFloat)->CGFloat{
        
        let temp = value / 100
        return temp * width
    }
}



struct DrawShape : View {
    
    var center : CGPoint
    var index : Int
    
    var body: some View{
        
        Path{path in
            
            path.move(to: self.center)
            path.addArc(center: self.center, radius: 180, startAngle: .init(degrees: self.from()), endAngle: .init(degrees: self.to()), clockwise: false)
        }
        .fill(data[index].color)
    }
    
    // since angle ids continuous so we need to calculate the angles before and add with the current to get exact angle.....
    
    func from()->Double{
        
        if index == 0{
            
            return 0
        }
        else{
            var temp : Double = 0
            
            for i in 0...index-1{
                
                temp += Double(data[i].percent / 100) * 360
            }
            
            return temp
        }
    }
    
    func to()->Double{
        
        //coverting percentage to angle.....
        
        var temp : Double = 0
        
        //because we nuud the current degree...
        for i in 0...index{
            
            temp += Double(data[i].percent / 100) * 360
        }
        
        return temp
    }
}


// sample data...
struct Pie : Identifiable{
    
    var id : Int
    var percent : CGFloat
    var name : String
    var color : Color
}


var data = [
    
    Pie(id:0, percent: 10, name: "食費", color: Color("Color")),
    Pie(id:1, percent: 15, name: "外食費", color: Color("Color-1")),
    Pie(id:2, percent: 20, name: "日用品", color: Color("Color-2")),
    Pie(id:3, percent: 20, name: "交通費", color: Color("Color-3")),
    Pie(id:4, percent: 35, name: "その他", color: Color("Color-4")),
]


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        HomeTabView()
        CalenderTabView()
        PieChartTabView()
    }
}

