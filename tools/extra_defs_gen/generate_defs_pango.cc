/* Copyright (C) 2001 The Free Software Foundation
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this library; if not, see <https://www.gnu.org/licenses/>.
 */

#include <glibmm_generate_extra_defs/generate_extra_defs.h>
#include <pango/pango.h>
#include <pango/pangocairo.h>

int main(int, char**)
{
  // g_type_init() is deprecated as of glib-2.36.
  // g_type_init();

  std::cout << get_defs(PANGO_TYPE_CONTEXT)        << std::endl
            << get_defs(PANGO_TYPE_FONT)           << std::endl
            << get_defs(PANGO_TYPE_FONT_FACE)      << std::endl
            << get_defs(PANGO_TYPE_FONT_FAMILY)    << std::endl
            << get_defs(PANGO_TYPE_FONT_MAP)       << std::endl
            << get_defs(PANGO_TYPE_CAIRO_FONT)     << std::endl
            << get_defs(PANGO_TYPE_CAIRO_FONT_MAP) << std::endl
            << get_defs(PANGO_TYPE_FONTSET)        << std::endl
            << get_defs(PANGO_TYPE_LAYOUT)         << std::endl
            << get_defs(PANGO_TYPE_RENDERER)       << std::endl;
  return 0;
}
