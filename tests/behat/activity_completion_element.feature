@format @format_designer @javascript
Feature: Sections can be check activity completion element in designer format
  In order to rearrange my course contents
  As a teacher
  I need to check activiyt completion in designer format

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email            |
      | teacher1 | Teacher   | First        | teacher1@example.com |
      | student1 | Student   | First       | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format | coursedisplay | numsections | Enable completion tracking |
      | Course 1 | C1        | designer | 0             | 5           | yes                      |
    And the following "activities" exist:
      | activity   | name                   | intro                         | course | idnumber    | section | completionexpected        |
      | assign     | Test assignment name   | Test assignment description   | C1     | assign1     | 0       | ##last day of +5 days##   |
      | assign     | Test assignment name 1 | Test assignment1 description  | C1     | assign2     | 0       | 1   |
      | assign     | Test assignment name 2 | Test assignment2 description  | C1     | assign3     | 0       | ##5 days ago##            |
      | choice     | Test choice name       | Test choice description       | C1     | choice1     | 0       | ##tomorrow##              |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    Then I log out