Feature: Personalized Productivity Tips
    As a user
    I want ChatGPT to generate advice based on my Tasks
    To improve my workflow

    Scenario: Require contextual tips
        Given I have 3 overdue Tasks
        And I am on the dashboard
        When I click "I Need Productivity Help"
        Then the system should display a card with:
            """
            Productivity Suggestions:
            - Pomodoro Technique
            - Delegate 'Review contracts'
            - Block 2h without interruptions
            """