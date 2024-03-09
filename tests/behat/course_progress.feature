@local @local_designer @designer_course_progress
Feature: To display the section background image & color options
    In order to use the features
    As admin
    I need to be able to configure the designer plugin to display the section background option

    Background:
        Given the following "categories" exist:
            | name  | category | idnumber |
            | Cat 1 | 0        | CAT1     |
        And the following "course" exist:
            | fullname    | shortname | category | enablecompletion |
            | Course 1    | C1        | 0        |  1         |
            | Course 2    | C2        | 0        |  1         |
            | Course 3    | C3        | 0        |  1         |
        And the following "activities" exist:
            | activity | name       | course | idnumber |  intro           | section  |completion|
            | page     | Test page1 | C1     | page1    | Page description | 1        | 1        |
            | page     | Test page4 | C1     | page4    | Page description | 1        | 1        |
            | page     | Test page5 | C1     | page5    | Page description | 0        | 1        |
            | page     | Test page2 | C2     | page1    | Page description | 2        | 1        |
            | page     | Test page3 | C3     | page1    | Page description | 3        | 1        |
        And the following "users" exist:
            | username | firstname | lastname | email                   |
            | student1 | Student   | First    | student1@example.com    |
            | student2 | Student   | Two      | student2@example.com    |
            | student3 | Student   | Three    | student3@example.com    |
        And the following "course enrolments" exist:
            | user | course | role             |   timestart | timeend   |
            | student1 | C1 | student          |   0         |     0     |
            | student1 | C2 | student          |   0         |     0     |
            | student1 | C3 | student          |   0         |     0     |
            | student2 | C2 | student          |   0         |     0     |
            | student2 | C3 | student          |   0         |     0     |
            | admin    | C1 | manager          |   0         |     0     |
            | admin    | C2 | manager          |   0         |     0     |
        And I log in as "admin"
        And I am on "Course 1" course homepage
        And I navigate to "Course completion" in current page administration
        And I expand all fieldsets
        And I set the field "Test page1" to "1"
        And I set the field "Test page4" to "1"
        And I press "Save changes"
        And I am on "Course 2" course homepage
        And I navigate to "Course completion" in current page administration
        And I expand all fieldsets
        And I set the field "Test page2" to "1"
        And I press "Save changes"

    @javascript
    Scenario: Display the course completion progress sorted by completion date
    Given I log in as "admin"
        And I am on "Course 1" course homepage
        And I click on "Settings" "link" in the ".secondary-navigation" "css_element"
        And I expand all fieldsets
        And I set the field "Format" to "Designer format"
        And I press "Save and display"
        And I am on "Course 1" course homepage
        And I turn block editing mode on
        And I am on the "Test page4" "page activity" page
        And I click on "Settings" "link" in the ".secondary-navigation" "css_element"
        And I expand all fieldsets
        And I set the following fields to these values:
            | id_completionexpected_enabled | 1 |
            | Set reminder in Timeline      | ##1 Feb 2024 08:00## |
        And I press "Save and display"
        And I log out
        And I am on the "Course 1" course page logged in as student1
        And I am on the "Test page5" "page activity" page
        And I press "Mark as done"
        And I am on "Course 1" course homepage
        Then ".completion-info .badge-success" "css_element" should exist
        And I am on the "Test page4" "page activity" page
        And I press "Mark as done"
        And I am on "Course 1" course homepage
        Then ".completion-info  .badge-due-success" "css_element" should exist
