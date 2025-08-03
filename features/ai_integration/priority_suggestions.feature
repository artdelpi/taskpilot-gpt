Feature: AI Task Prioritization
    As a User
    I want ChatGPT to suggest a priority order
    To focus on what matters most

    Scenario: Receive priority recommendations
        Given I have 5 unprioritized Tasks
        And I am on the "My List" page
        When I click "Optimize Priorities with AI"
        Then the system should return a suggested order
        And it should ask "Apply this order?"
