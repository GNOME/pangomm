#ifndef _PANGO_CAIROFONTMAPIMPL_H
#define _PANGO_CAIROFONTMAPIMPL_H

/* Copyright (C) 2021 The gtkmm Development Team
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <pangommconfig.h>
#include <pangomm/cairofontmap.h>
#include <pangomm/fontmap.h>

namespace Pango
{

/** %Gdk::CairoFontMapImpl is a Pango::FontMap that implements the Pango::CairoFontMap interface.
 *
 * The PangoCairoFontMap interface can be implemented by C classes that
 * derive from PangoFontMap. No public %Pango class implements PangoCairoFontMap.
 * Some %Pango functions, such as pango_cairo_font_map_get_default(), return an object
 * of a class which is derived from PangoFontMap and implements PangoCairoFontMap.
 * Since that C class is not public, it's not wrapped in a C++ class.
 * A C object of such a class can be wrapped in a %Pango::CairoFontMapImpl object.
 * %Pango::CairoFontMapImpl does not directly correspond to any %Pango class.
 *
 * This class is intended only for wrapping C objects returned from %Pango functions.
 *
 * @see Pango::CairoFontMap::get_default()
 * @newin{2,50}
 */
class PANGOMM_API CairoFontMapImpl : public CairoFontMap, public FontMap
{
#ifndef DOXYGEN_SHOULD_SKIP_THIS
protected:
  explicit CairoFontMapImpl(PangoFontMap* castitem);
  friend class FontMap_Class;

  // noncopyable
  CairoFontMapImpl(const CairoFontMapImpl&) = delete;
  CairoFontMapImpl& operator=(const CairoFontMapImpl&) = delete;
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

public:
  CairoFontMapImpl(CairoFontMapImpl&& src) noexcept;
  CairoFontMapImpl& operator=(CairoFontMapImpl&& src) noexcept;

  ~CairoFontMapImpl() noexcept override;
};

} // namespace Pango

#endif /* _PANGO_CAIROFONTMAPIMPL_H */
