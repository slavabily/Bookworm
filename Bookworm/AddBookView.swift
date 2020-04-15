//
//  AddBookView.swift
//  Bookworm
//
//  Created by slava bily on 13/4/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                Section {
                    Button("Save") {
                        if !self.genre.isEmpty {
                            let newBook = Book(context: self.moc)
                            newBook.title = self.title
                            newBook.author = self.author
                            newBook.rating = Int16(self.rating)
                            newBook.genre = self.genre
                            newBook.review = self.review
                            newBook.date = Date()
                            
                            try? self.moc.save()
                        } else {
                            self.showingAlert = true
                            print(self.showingAlert)
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Genre is not selected"), message: Text("Please, select someone from the list"), dismissButton: .default(Text("OK")))
            })
        .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
