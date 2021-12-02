<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Contains the designer section course format output class.
 *
 * @package   format_designer
 * @copyright 2021 bdecent gmbh <https://bdecent.de>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
namespace format_designer\output\courseformat\content;
use core_courseformat\output\local\content\section as section_base;
use stdClass;

/**
 * Base class to render a section.
 *
 * @package   format_designer
 * @copyright 2021 bdecent gmbh <https://bdecent.de>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class section extends section_base {
    /**
     * Export this data so it can be used as the context for a mustache template.
     *
     * @param renderer_base $output typically, the renderer that's calling this function
     * @return array data context for a mustache template
     */
    public function export_for_template(\renderer_base $output): stdClass {
        $format = $this->format;
        $course = $format->get_course();
        $thissection = $this->thissection;
        $singlesection = $format->get_section_number();

        $summary = new $this->summaryclass($format, $thissection);
        $availability = new $this->availabilityclass($format, $thissection);

        $data = (object)[
            'num' => $thissection->section ?? '0',
            'id' => $thissection->id,
            'sectionreturnid' => $singlesection,
            'insertafter' => false,
            'summary' => $summary->export_for_template($output),
            'availability' => $availability->export_for_template($output),
        ];
        $restrictsection = false;
        // Check restrict the section.
        if (!$thissection->uservisible) {
            if ($thissection->availableinfo) {
                $restrictsection = true;
            }
        }
        $data->restrictsection = $restrictsection;
        // Check if it is a stealth sections (orphaned).
        if ($thissection->section > $format->get_last_section_number()) {
            $data->isstealth = true;
            $data->ishidden = true;
        }

        if ($format->show_editor()) {
            if (empty($this->hidecontrols)) {
                $controlmenu = new $this->controlmenuclass($format, $thissection);
                $data->controlmenu = $controlmenu->export_for_template($output);
            }
            if (empty($data->isstealth)) {
                $data->cmcontrols = $output->course_section_add_cm_control($course, $thissection->section, $singlesection);
            }
        }

        $coursedisplay = $course->coursedisplay ?? COURSE_DISPLAY_SINGLEPAGE;
        if ($coursedisplay == COURSE_DISPLAY_MULTIPAGE) {
            $data->iscoursedisplaymultipage = true;
        }

        if ($course->id == SITEID) {
            $data->sitehome = true;
        }

        $data->contentexpanded = true;
        $preferences = $format->get_sections_preferences();
        if (isset($preferences[$thissection->id])) {
            $sectionpreferences = $preferences[$thissection->id];
            if (!empty($sectionpreferences->contentcollapsed)) {
                $data->contentexpanded = false;
            }
        }

        if ($thissection->section == 0) {
            // Section zero is always visible only as a cmlist.
            $cmlist = new $this->cmlistclass($format, $thissection);
            $data->cmlist = $cmlist->export_for_template($output);

            $header = new $this->headerclass($format, $thissection);
            if (empty($this->hidetitle)) {
                $data->header = $header->export_for_template($output);
            }
            return $data;
        }

        // When a section is displayed alone the title goes over the section, not inside it.
        $header = new $this->headerclass($format, $thissection);

        if ($thissection->section == $singlesection) {
            if (empty($this->hidetitle)) {
                $data->singleheader = $header->export_for_template($output);
            }
        } else {
            if (empty($this->hidetitle)) {
                $data->header = $header->export_for_template($output);
            }

            // Add activities summary if necessary.
            if (!$format->show_editor() && $course->coursedisplay == COURSE_DISPLAY_MULTIPAGE) {
                $cmsummary = new $this->cmsummaryclass($format, $thissection);
                $data->cmsummary = $cmsummary->export_for_template($output);

                $data->onlysummary = true;
                if (!$format->is_section_current($thissection)) {
                    // In multipage, only the current section (and the section zero) has elements.
                    return $data;
                }
            }
        }

        // Add the cm list.
        if ($thissection->uservisible) {
            $cmlist = new $this->cmlistclass($format, $thissection);
            $data->cmlist = $cmlist->export_for_template($output);
        }

        if (!$thissection->visible) {
            $data->ishidden = true;
        }
        if ($format->is_section_current($thissection)) {
            $data->iscurrent = true;
            $data->currentlink = get_accesshide(
                get_string('currentsection', 'format_'.$format->get_format())
            );
        }

        return $data;
    }
}
