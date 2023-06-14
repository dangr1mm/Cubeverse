//
//  CommentsList.swift
//  Cubeverse
//
//  Created by Dan Grimm on 07/05/23.
//

import SwiftUI

// MARK: - CommentsList

struct CommentsList: View {
    @StateObject var viewModel: CommentsViewModel
    
    var body: some View {
        VStack {
            Group {
                switch viewModel.comments {
                case .loading:
                    ProgressView()
                        .onAppear {
                            viewModel.fetchComments()
                        }
                case let .error(error):
                    EmptyListView(
                        title: "Cannot Load Comments",
                        message: error.localizedDescription,
                        retryAction: {
                            viewModel.fetchComments()
                        }
                    )
                case .empty:
                    VStack {
                        Spacer()
                        EmptyListView(
                            title: "No Comments",
                            message: "Be the first to leave a comment."
                        )
                        Spacer()
                    }
                case let .loaded(comments):
                    List(comments) { comment in
                        CommentRow(viewModel: viewModel.makeCommentRowViewModel(for: comment))
                    }
                    .animation(.default, value: comments)
                }
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)

            // for some reason this toolbarItem with bottom placement doesn't work on real devices as of now (May 2023 xcode 14.3)
            //        .toolbar {
            //            ToolbarItem(placement: .bottomBar) {
            //                NewCommentForm(viewModel: viewModel.makeNewCommentViewModel())
            //            }
            //        }
            Spacer()
            NewCommentForm(viewModel: viewModel.makeNewCommentViewModel())
        }
    }
}

// MARK: - NewCommentForm

private extension CommentsList {
    struct NewCommentForm: View {
        @StateObject var viewModel: FormViewModel<Comment>
        
        var body: some View {
            HStack {
                TextField("Comment", text: $viewModel.content)
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Image(systemName: "paperplane")
                    }
                }
            }
            .alert("Cannot Post Comment", error: $viewModel.error)
            .animation(.default, value: viewModel.isWorking)
            .padding()
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct CommentsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Comment.testComment]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    private struct ListPreview: View {
        let state: Loadable<[Comment]>
        
        var body: some View {
            NavigationView {
                CommentsList(viewModel: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: state)))
            }
        }
    }
}
#endif