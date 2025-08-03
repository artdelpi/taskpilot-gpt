Feature: AI-Powered Task Breakdown
    As a User
    I want ChatGPT to slipt complex tasks into simpler subtasks
    So that I can improve manageability and increase productivity

    Scenario: Generate subtasks automatically
        Given I have a task "Organize online workshop" created
        And I am on the task details page
        When I click "Split into Subtasks with AI"
        And I confirm the action
        Then I should see a list of suggested subtasks like:
            |Subtask                      |
            |Define the workshop agenda   |
            |Invite guest speakers        |
            |Set up the video platform    |
            |Prepare registration form    |
            |Send invitations to attendees|
            |Test audio and video         |
        And each subtask should be saved as a child of the main task
    
    Scenario: Edit suggested subtasks before saving
        Given I have a task "Prepare presentation"
        And I am on the task details page
        When I click "Split into Subtasks with AI"
        And I see a list of suggested subtasks
            |Subtask      |
            |Create slides|
            |Add diagrams |
        And I edit the list to add "Rehearse presentation"
        And I remove "Add diagrams"
        And I confirm the action
        Then only "Create slides" and "Rehearse presentation" should be saved as subtasks
        