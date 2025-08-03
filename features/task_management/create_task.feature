Feature: Create Task
    As a registered User
    I want to create a new task
    So that I can organize my work

    Scenario: Create task with valid data
        Given I am logged into the system
        And I am on the "My Tasks" page
        When I click "New Task"
        And I fill in:
            |Title      |Finish documentation|
            |Description|Review PDF files    |
            |Priority   |High                |
            |Due Date   |2025-08-03          |
        And I click "Save"
        Then the task "Finish documentation" should apper in the list
        And its status should be "Pending..."

    Scenario: Attempt to create task without title
        Given I am logged into the system
        And I am on the "My Tasks" page
        When I click "New Task"
        And I fill in:
            |Description|Review PDF files|
            |Priority   |High            |
            |Due Date   |2025-08-03      |
        And I click "Save"
        Then I should see an error message "No title was given (required)"
        And the task should not be created

    Scenario: Attempt to create task with invalid due date
        Given I am logged into the system
        And I am on the "My Tasks" page
        When I click "New Task"
        And I fill in:
            |Title      |Finish documentation|
            |Description|Review PDF files    |
            |Priority   |High                |
            |Due Date   |2000-01-01          |
        And I click "Save"
        Then I should see an error message "Due Date is invalid"
        And the task should not be created

    Scenario: Unauthenticated user tries to create a task
        Given I am not logged into the system
        When I try to access the "My Tasks" page
        Then I should be redirected to the login page
