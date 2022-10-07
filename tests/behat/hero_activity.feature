@format @format_designer @javascript @designer_hero_activity
Feature: Activities can be check hero activity in designer format
  In order to rearrange my course contents
  As a teacher
  I need to check hero activity in designer format

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email            |
      | teacher1 | Teacher   | First        | teacher1@example.com |
      | student1 | Student   | First       | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format | coursedisplay | numsections | Enable completion tracking |
      | Course 1 | C1        | designer | 0             | 5           | yes                      |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |

  Scenario: Check the hero activity to see everywhere
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I press "Add an activity or resource"
    And I click on "Add a new Forum" "link" in the "Add an activity or resource" "dialogue"
    And I follow "Expand all"
    And I set the field "Forum name" to "My forum name"
    And I set the field "Show as tab" to "Everywhere"
    And I set the field "Order" to "1"
    And I press "Save and return to course"
    And I press "Add an activity or resource"
    And I click on "Add a new Forum" "link" in the "Add an activity or resource" "dialogue"
    And I follow "Expand all"
    And I set the field "Forum name" to "My forum name1"
    And I set the field "Show as tab" to "Only on course main page"
    And I set the field "Order" to "-1"
    And I press "Save and return to course"
    Then I wait "3" seconds
    And I reload the page
    Then I check heroactivity position "My forum name" "3"
    Then I check heroactivity position "My forum name1" "1"
    And I am on the "My forum name" "forum activity" page
    Then I wait "3" seconds
    And I reload the page
    Then I check heroactivity position "My forum name" "2"
    And I log out

  # Scenario: Check the hero activity to see coursepage
  #   Given I log in as "teacher1"
  #   And I am on "Course 1" course homepage with editing mode on
  #   Then I am on the "Test assignment name" "assign activity" page
  #   And I navigate to "Settings" in current page administration
  #   And I follow "Expand all"
  #   And I set the field "Show as tab" to "Only on course main page"
  #   And I set the field "Order" to "1"
  #   And I press "Save and return to course"
  #   Then I am on the "Test assignment name1" "assign activity" page
  #   And I navigate to "Settings" in current page administration
  #   And I follow "Expand all"
  #   And I set the field "Show as tab" to "Only on course main page"
  #   And I set the field "Order" to "-1"
  #   And I press "Save and return to course"
  #   And I am on "Course 1" course homepage
  #   And I wait until the page is ready
  #   Then I check heroactivity position "Test assignment name" "3"
  #   Then I check heroactivity position "Test assignment name1" "1"
  #   And I am on the "Test assignment name" "assign activity" page
  #   And I wait until the page is ready
  #   Then I check heroactivity not in the position "Test assignment name" "3"
  #   Then I check heroactivity not in the position "Test assignment name1" "1"
  #   And I am on the "Test assignment name1" "assign activity" page
  #   And I wait until the page is ready
  #   Then I check heroactivity not in the position "Test assignment name" "3"
  #   Then I check heroactivity not in the position "Test assignment name1" "1"
  #   And I log out

  # Scenario: Check the hero activity workflow.
  #   Given I log in as "teacher1"
  #   And I am on "Course 1" course homepage with editing mode on
  #   And I am on the "Test assignment name" "assign activity" page
  #   And I navigate to "Settings" in current page administration
  #   And I follow "Expand all"
  #   And I set the field "Show as tab" to "Only on course main page"
  #   And I set the field "Order" to "-1"
  #   Then I press "Save and return to course"
  #   And I am on "Course 1" course homepage
  #   And I wait until the page is ready
  #   Then I check heroactivity position "Test assignment name" "1"
  #   And I am on the "Test assignment name" "assign activity" page
  #   And I wait until the page is ready
  #   Then I check heroactivity not in the position "Test assignment name1" "1"
