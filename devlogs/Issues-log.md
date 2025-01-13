# Overview
This marked down file highlights all of the issues/problems I have faced developing this app.
- Problem statement.
- Status.
- Solution.

**Code were not copy and pasted to AI to solve these problems.**
AI was used as a general guide, by asking questions such as "how does .onAppear affect sheets?"

## Issues:

### When returning to SessionListView after adding a session, the sessions list are not updated.
**FIXED**

Thinking process:
- Could it be because, both files (SessionListView, AddSessionView) are using different viewModel instances?
- **Initialised viewModel in ContentView.swift (root view file).**
    - Instead of initialising the viewModel each file.
- That seems to work!

### Unable to show add or edit sheet. 
**FIXED**

Thinking process:
- When both/or (Add/Rename) buttons are pressed no sheet presents.
- For this problem, I was using 2 .sheet() calls.
- Looked for youtube videos on how to display dynamic sheets.
- **Used an enum class to be able to dynamically call which sheet is needed with 1 .sheet() call.**


### Session object is not being passed into the EditSessionView sheet from SessionListView properly.
**FIXED**

Current workflow:
- Edit button toggles edit mode.
- When edit mode is true, rename button appears next to each session in the session list.
- When the rename button is pressed, the session is then copied into the struct variable selectedSession.
- The sheet is then triggered with the appropriate enum class.
- The sheet class the EditSessionView() with, and we pass in the selectedSession variable.
- Tried passing in session id instead. Didn't work.

- Since we are passing the instance of the viewModel.
- **Created a viewModel function that sets a published variable 'selectedSession'.**
    - This method is called when that rename button is pressed in SessionListView.
    
Thought process:
- If I can't pass the object through the view, then I will just create a pivot in the viewModel.
    

### SessionListView not updating session list after a session is renamed.
**FIXED**

- After adding multiple log statements in relative files.
    - Log statements show that Core Data functionality works as intended.
    - It's the views that are not working properly.
- Added an init in SessionCardView.


### View is not updating when delete button in edit mode is pressed.
**WORKING PROGRESS...**
- The swipe to delete works.
- Edit mode delete button:
    - Delete's the session from coredatabase properly.
    - But the view crashes.
    - Crash report states = 'implicitly unwrapped optional in SessionListView.swift at line 102.'

Code:
```
    private func displayRenameButton(session: Session) -> some View {
        Button(action: {
            print("SessionListView: Rename button pressed")  // Log
>>>         viewModel.selectSession(id: session.id!)  
            print("SessionListView: Session to update = \(String(describing: session.name))")  // Log
            
            sheetConfig = .edit
            toggleEditMode()
        }) {
            Image(systemName: "pencil")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
```
- Which is my renameButton that is next to the delete button, which is tied to the cardView.
    

### In edit mode, rename button is not recognised when pressed.
**WORKING PROGRESS...**
- When in edit mode and I try to press the rename button.
- It calls delete functionality instead.
