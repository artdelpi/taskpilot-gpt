Feature: Task Sharing
  As a team leader
  I want to assign tasks to team members
  To distribute workload

  Scenario: Assign task to a colleague
    Given I have the task "Create presentation"
    And my team has the user "ana@company.com"
    When I click "Share"
    And I select "ana@company.com"
    And I set the due date to "2025-11-15"
    Then the task should appear in "Ana's" list
    And I should get a notification "Task assigned successfully"
