module heif.heif;

/*
 * HEIF codec.
 * Copyright (c) 2017 struktur AG, Dirk Farin <farin@struktur.de>
 *
 * This file is part of libheif.
 *
 * libheif is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version.
 *
 * libheif is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with libheif.  If not, see <http://www.gnu.org/licenses/>.
 */

extern (C):

/* Numeric representation of the version */
enum LIBHEIF_NUMERIC_VERSION = (1 << 24) | (12 << 16) | (0 << 8) | 0;

/* Version string */
enum LIBHEIF_VERSION = "1.12.0";

// API versions table
//
// release    depth.rep   dec.options   enc.options   heif_reader   heif_writer  col.profile
// -----------------------------------------------------------------------------------------
//  1.0          1             1           N/A           N/A           N/A          N/A
//  1.1          1             1           N/A           N/A            1           N/A
//  1.3          1             1            1             1             1           N/A
//  1.4          1             1            1             1             1            1
//  1.7          1             2            1             1             1            1
//  1.9.2        1             2            2             1             1            1
//  1.10         1             2            3             1             1            1
//  1.11         1             2            4             1             1            1

extern (D) auto heif_fourcc(T0, T1, T2, T3)(auto ref T0 a, auto ref T1 b, auto ref T2 c, auto ref T3 d)
{
    return (a << 24) | (b << 16) | (c << 8) | d;
}

/* === version numbers === */

// Version string of linked libheif library.
const(char)* heif_get_version ();
// Numeric version of linked libheif library, encoded as 0xHHMMLL00 = HH.MM.LL.
uint heif_get_version_number ();

// Numeric part "HH" from above.
int heif_get_version_number_major ();
// Numeric part "MM" from above.
int heif_get_version_number_minor ();
// Numeric part "LL" from above.
int heif_get_version_number_maintenance ();

// Helper macros to check for given versions of libheif at compile time.
extern (D) auto LIBHEIF_MAKE_VERSION(T0, T1, T2)(auto ref T0 h, auto ref T1 m, auto ref T2 l)
{
    return h << 24 | m << 16 | l << 8;
}

extern (D) auto LIBHEIF_HAVE_VERSION(T0, T1, T2)(auto ref T0 h, auto ref T1 m, auto ref T2 l)
{
    return LIBHEIF_NUMERIC_VERSION >= LIBHEIF_MAKE_VERSION(h, m, l);
}

struct heif_context;
struct heif_image_handle;
struct heif_image;

enum heif_error_code
{
    // Everything ok, no error occurred.
    heif_error_Ok = 0,

    // Input file does not exist.
    heif_error_Input_does_not_exist = 1,

    // Error in input file. Corrupted or invalid content.
    heif_error_Invalid_input = 2,

    // Input file type is not supported.
    heif_error_Unsupported_filetype = 3,

    // Image requires an unsupported decoder feature.
    heif_error_Unsupported_feature = 4,

    // Library API has been used in an invalid way.
    heif_error_Usage_error = 5,

    // Could not allocate enough memory.
    heif_error_Memory_allocation_error = 6,

    // The decoder plugin generated an error
    heif_error_Decoder_plugin_error = 7,

    // The encoder plugin generated an error
    heif_error_Encoder_plugin_error = 8,

    // Error during encoding or when writing to the output
    heif_error_Encoding_error = 9,

    // Application has asked for a color profile type that does not exist
    heif_error_Color_profile_does_not_exist = 10
}

enum heif_suberror_code
{
    // no further information available
    heif_suberror_Unspecified = 0,

    // --- Invalid_input ---

    // End of data reached unexpectedly.
    heif_suberror_End_of_data = 100,

    // Size of box (defined in header) is wrong
    heif_suberror_Invalid_box_size = 101,

    // Mandatory 'ftyp' box is missing
    heif_suberror_No_ftyp_box = 102,

    heif_suberror_No_idat_box = 103,

    heif_suberror_No_meta_box = 104,

    heif_suberror_No_hdlr_box = 105,

    heif_suberror_No_hvcC_box = 106,

    heif_suberror_No_pitm_box = 107,

    heif_suberror_No_ipco_box = 108,

    heif_suberror_No_ipma_box = 109,

    heif_suberror_No_iloc_box = 110,

    heif_suberror_No_iinf_box = 111,

    heif_suberror_No_iprp_box = 112,

    heif_suberror_No_iref_box = 113,

    heif_suberror_No_pict_handler = 114,

    // An item property referenced in the 'ipma' box is not existing in the 'ipco' container.
    heif_suberror_Ipma_box_references_nonexisting_property = 115,

    // No properties have been assigned to an item.
    heif_suberror_No_properties_assigned_to_item = 116,

    // Image has no (compressed) data
    heif_suberror_No_item_data = 117,

    // Invalid specification of image grid (tiled image)
    heif_suberror_Invalid_grid_data = 118,

    // Tile-images in a grid image are missing
    heif_suberror_Missing_grid_images = 119,

    heif_suberror_Invalid_clean_aperture = 120,

    // Invalid specification of overlay image
    heif_suberror_Invalid_overlay_data = 121,

    // Overlay image completely outside of visible canvas area
    heif_suberror_Overlay_image_outside_of_canvas = 122,

    heif_suberror_Auxiliary_image_type_unspecified = 123,

    heif_suberror_No_or_invalid_primary_item = 124,

    heif_suberror_No_infe_box = 125,

    heif_suberror_Unknown_color_profile_type = 126,

    heif_suberror_Wrong_tile_image_chroma_format = 127,

    heif_suberror_Invalid_fractional_number = 128,

    heif_suberror_Invalid_image_size = 129,

    heif_suberror_Invalid_pixi_box = 130,

    heif_suberror_No_av1C_box = 131,

    heif_suberror_Wrong_tile_image_pixel_depth = 132,

    // --- Memory_allocation_error ---

    // A security limit preventing unreasonable memory allocations was exceeded by the input file.
    // Please check whether the file is valid. If it is, contact us so that we could increase the
    // security limits further.
    heif_suberror_Security_limit_exceeded = 1000,

    // --- Usage_error ---

    // An item ID was used that is not present in the file.
    heif_suberror_Nonexisting_item_referenced = 2000, // also used for Invalid_input

    // An API argument was given a NULL pointer, which is not allowed for that function.
    heif_suberror_Null_pointer_argument = 2001,

    // Image channel referenced that does not exist in the image
    heif_suberror_Nonexisting_image_channel_referenced = 2002,

    // The version of the passed plugin is not supported.
    heif_suberror_Unsupported_plugin_version = 2003,

    // The version of the passed writer is not supported.
    heif_suberror_Unsupported_writer_version = 2004,

    // The given (encoder) parameter name does not exist.
    heif_suberror_Unsupported_parameter = 2005,

    // The value for the given parameter is not in the valid range.
    heif_suberror_Invalid_parameter_value = 2006,

    // --- Unsupported_feature ---

    // Image was coded with an unsupported compression method.
    heif_suberror_Unsupported_codec = 3000,

    // Image is specified in an unknown way, e.g. as tiled grid image (which is supported)
    heif_suberror_Unsupported_image_type = 3001,

    heif_suberror_Unsupported_data_version = 3002,

    // The conversion of the source image to the requested chroma / colorspace is not supported.
    heif_suberror_Unsupported_color_conversion = 3003,

    heif_suberror_Unsupported_item_construction_method = 3004,

    // --- Encoder_plugin_error ---

    heif_suberror_Unsupported_bit_depth = 4000,

    // --- Encoding_error ---

    heif_suberror_Cannot_write_output_data = 5000
}

struct heif_error
{
    // main error category
    heif_error_code code;

    // more detailed error code
    heif_suberror_code subcode;

    // textual error message (is always defined, you do not have to check for NULL)
    const(char)* message;
}

alias heif_item_id = uint;

// ========================= file type check ======================

enum heif_filetype_result
{
    heif_filetype_no = 0,
    heif_filetype_yes_supported = 1, // it is heif and can be read by libheif
    heif_filetype_yes_unsupported = 2, // it is heif, but cannot be read by libheif
    heif_filetype_maybe = 3 // not sure whether it is an heif, try detection with more input data
}

// input data should be at least 12 bytes
heif_filetype_result heif_check_filetype (const(ubyte)* data, int len);

// DEPRECATED, use heif_brand2 instead
enum heif_brand
{
    heif_unknown_brand = 0,
    heif_heic = 1, // the usual HEIF images
    heif_heix = 2, // 10bit images, or anything that uses h265 with range extension
    heif_hevc = 3,
    heif_hevx = 4, // brands for image sequences
    heif_heim = 5, // multiview
    heif_heis = 6, // scalable
    heif_hevm = 7, // multiview sequence
    heif_hevs = 8, // scalable sequence
    heif_mif1 = 9, // image, any coding algorithm
    heif_msf1 = 10, // sequence, any coding algorithm
    heif_avif = 11,
    heif_avis = 12
}

// input data should be at least 12 bytes
// DEPRECATED, use heif_read_main_brand() instead
heif_brand heif_main_brand (const(ubyte)* data, int len);

alias heif_brand2 = uint;

// input data should be at least 12 bytes
heif_brand2 heif_read_main_brand (const(ubyte)* data, int len);

// 'brand_fourcc' must be 4 character long, but need not be 0-terminated
heif_brand2 heif_fourcc_to_brand (const(char)* brand_fourcc);

// the output buffer must be at least 4 bytes long
void heif_brand_to_fourcc (heif_brand2 brand, char* out_fourcc);

// 'brand_fourcc' must be 4 character long, but need not be 0-terminated
// returns 1 if file includes the brand, and 0 if it does not
// returns -1 if the provided data is not sufficient
//            (you should input at least as many bytes as indicated in the first 4 bytes of the file, usually ~50 bytes will do)
// returns -2 on other errors
int heif_has_compatible_brand (
    const(ubyte)* data,
    int len,
    const(char)* brand_fourcc);

// Returns an array of compatible brands. The array is allocated by this function and has to be freed with 'heif_free_list_of_compatible_brands()'.
// The number of entries is returned in out_size.
heif_error heif_list_compatible_brands (
    const(ubyte)* data,
    int len,
    heif_brand2** out_brands,
    int* out_size);

void heif_free_list_of_compatible_brands (heif_brand2* brands_list);

// Returns one of these MIME types:
// - image/heic           HEIF file using h265 compression
// - image/heif           HEIF file using any other compression
// - image/heic-sequence  HEIF image sequence using h265 compression
// - image/heif-sequence  HEIF image sequence using any other compression
// - image/jpeg    JPEG image
// - image/png     PNG image
// If the format could not be detected, an empty string is returned.
//
// Provide at least 12 bytes of input. With less input, its format might not
// be detected. You may also provide more input to increase detection accuracy.
//
// Note that JPEG and PNG images cannot be decoded by libheif even though the
// formats are detected by this function.
const(char)* heif_get_file_mime_type (const(ubyte)* data, int len);

// ========================= heif_context =========================
// A heif_context represents a HEIF file that has been read.
// In the future, you will also be able to add pictures to a heif_context
// and write it into a file again.

// Allocate a new context for reading HEIF files.
// Has to be freed again with heif_context_free().
heif_context* heif_context_alloc ();

// Free a previously allocated HEIF context. You should not free a context twice.
void heif_context_free (heif_context*);

struct heif_reading_options;

enum heif_reader_grow_status
{
    heif_reader_grow_status_size_reached = 0, // requested size has been reached, we can read until this point
    heif_reader_grow_status_timeout = 1, // size has not been reached yet, but it may still grow further
    heif_reader_grow_status_size_beyond_eof = 2 // size has not been reached and never will. The file has grown to its full size
}

struct heif_reader
{
    // API version supported by this reader
    int reader_api_version;

    // --- version 1 functions ---
    long function (void* userdata) get_position;

    // The functions read(), and seek() return 0 on success.
    // Generally, libheif will make sure that we do not read past the file size.
    int function (void* data, size_t size, void* userdata) read;

    int function (long position, void* userdata) seek;

    // When calling this function, libheif wants to make sure that it can read the file
    // up to 'target_size'. This is useful when the file is currently downloaded and may
    // grow with time. You may, for example, extract the image sizes even before the actual
    // compressed image data has been completely downloaded.
    //
    // Even if your input files will not grow, you will have to implement at least
    // detection whether the target_size is above the (fixed) file length
    // (in this case, return 'size_beyond_eof').
    heif_reader_grow_status function (long target_size, void* userdata) wait_for_file_size;
}

// Read a HEIF file from a named disk file.
// The heif_reading_options should currently be set to NULL.
heif_error heif_context_read_from_file (
    heif_context*,
    const(char)* filename,
    const(heif_reading_options)*);

// Read a HEIF file stored completely in memory.
// The heif_reading_options should currently be set to NULL.
// DEPRECATED: use heif_context_read_from_memory_without_copy() instead.
heif_error heif_context_read_from_memory (
    heif_context*,
    const(void)* mem,
    size_t size,
    const(heif_reading_options)*);

// Same as heif_context_read_from_memory() except that the provided memory is not copied.
// That means, you will have to keep the memory area alive as long as you use the heif_context.
heif_error heif_context_read_from_memory_without_copy (
    heif_context*,
    const(void)* mem,
    size_t size,
    const(heif_reading_options)*);

heif_error heif_context_read_from_reader (
    heif_context*,
    const(heif_reader)* reader,
    void* userdata,
    const(heif_reading_options)*);

// Number of top-level images in the HEIF file. This does not include the thumbnails or the
// tile images that are composed to an image grid. You can get access to the thumbnails via
// the main image handle.
int heif_context_get_number_of_top_level_images (heif_context* ctx);

int heif_context_is_top_level_image_ID (heif_context* ctx, heif_item_id id);

// Fills in image IDs into the user-supplied int-array 'ID_array', preallocated with 'count' entries.
// Function returns the total number of IDs filled into the array.
int heif_context_get_list_of_top_level_image_IDs (
    heif_context* ctx,
    heif_item_id* ID_array,
    int count);

heif_error heif_context_get_primary_image_ID (
    heif_context* ctx,
    heif_item_id* id);

// Get a handle to the primary image of the HEIF file.
// This is the image that should be displayed primarily when there are several images in the file.
heif_error heif_context_get_primary_image_handle (
    heif_context* ctx,
    heif_image_handle**);

// Get the handle for a specific top-level image from an image ID.
heif_error heif_context_get_image_handle (
    heif_context* ctx,
    heif_item_id id,
    heif_image_handle**);

// Print information about the boxes of a HEIF file to file descriptor.
// This is for debugging and informational purposes only. You should not rely on
// the output having a specific format. At best, you should not use this at all.
void heif_context_debug_dump_boxes_to_file (heif_context* ctx, int fd);

void heif_context_set_maximum_image_size_limit (
    heif_context* ctx,
    int maximum_width);

// ========================= heif_image_handle =========================

// An heif_image_handle is a handle to a logical image in the HEIF file.
// To get the actual pixel data, you have to decode the handle to an heif_image.
// An heif_image_handle also gives you access to the thumbnails and Exif data
// associated with an image.

// Once you obtained an heif_image_handle, you can already release the heif_context,
// since it is internally ref-counted.

// Release image handle.
void heif_image_handle_release (const(heif_image_handle)*);

// Check whether the given image_handle is the primary image of the file.
int heif_image_handle_is_primary_image (const(heif_image_handle)* handle);

// Get the resolution of an image.
int heif_image_handle_get_width (const(heif_image_handle)* handle);

int heif_image_handle_get_height (const(heif_image_handle)* handle);

int heif_image_handle_has_alpha_channel (const(heif_image_handle)*);

int heif_image_handle_is_premultiplied_alpha (const(heif_image_handle)*);

// Returns -1 on error, e.g. if this information is not present in the image.
int heif_image_handle_get_luma_bits_per_pixel (const(heif_image_handle)*);

// Returns -1 on error, e.g. if this information is not present in the image.
int heif_image_handle_get_chroma_bits_per_pixel (const(heif_image_handle)*);

// Get the image width from the 'ispe' box. This is the original image size without
// any transformations applied to it. Do not use this unless you know exactly what
// you are doing.
int heif_image_handle_get_ispe_width (const(heif_image_handle)* handle);

int heif_image_handle_get_ispe_height (const(heif_image_handle)* handle);

// ------------------------- depth images -------------------------

int heif_image_handle_has_depth_image (const(heif_image_handle)*);

int heif_image_handle_get_number_of_depth_images (
    const(heif_image_handle)* handle);

int heif_image_handle_get_list_of_depth_image_IDs (
    const(heif_image_handle)* handle,
    heif_item_id* ids,
    int count);

heif_error heif_image_handle_get_depth_image_handle (
    const(heif_image_handle)* handle,
    heif_item_id depth_image_id,
    heif_image_handle** out_depth_handle);

enum heif_depth_representation_type
{
    heif_depth_representation_type_uniform_inverse_Z = 0,
    heif_depth_representation_type_uniform_disparity = 1,
    heif_depth_representation_type_uniform_Z = 2,
    heif_depth_representation_type_nonuniform_disparity = 3
}

struct heif_depth_representation_info
{
    ubyte version_;

    // version 1 fields

    ubyte has_z_near;
    ubyte has_z_far;
    ubyte has_d_min;
    ubyte has_d_max;

    double z_near;
    double z_far;
    double d_min;
    double d_max;

    heif_depth_representation_type depth_representation_type;
    uint disparity_reference_view;

    uint depth_nonlinear_representation_model_size;
    ubyte* depth_nonlinear_representation_model;

    // version 2 fields below
}

void heif_depth_representation_info_free (
    const(heif_depth_representation_info)* info);

// Returns true when there is depth_representation_info available
// Note 1: depth_image_id is currently unused because we support only one depth channel per image, but
// you should still provide the correct ID for future compatibility.
// Note 2: Because of an API bug before v1.11.0, the function also works when 'handle' is the handle of the depth image.
// However, you should pass the handle of the main image. Please adapt your code if needed.
int heif_image_handle_get_depth_image_representation_info (
    const(heif_image_handle)* handle,
    heif_item_id depth_image_id,
    const(heif_depth_representation_info*)* out_);

// ------------------------- thumbnails -------------------------

// List the number of thumbnails assigned to this image handle. Usually 0 or 1.
int heif_image_handle_get_number_of_thumbnails (
    const(heif_image_handle)* handle);

int heif_image_handle_get_list_of_thumbnail_IDs (
    const(heif_image_handle)* handle,
    heif_item_id* ids,
    int count);

// Get the image handle of a thumbnail image.
heif_error heif_image_handle_get_thumbnail (
    const(heif_image_handle)* main_image_handle,
    heif_item_id thumbnail_id,
    heif_image_handle** out_thumbnail_handle);

// ------------------------- auxiliary images -------------------------

enum LIBHEIF_AUX_IMAGE_FILTER_OMIT_ALPHA = 1UL << 1;
enum LIBHEIF_AUX_IMAGE_FILTER_OMIT_DEPTH = 2UL << 1;

// List the number of auxiliary images assigned to this image handle.
int heif_image_handle_get_number_of_auxiliary_images (
    const(heif_image_handle)* handle,
    int aux_filter);

int heif_image_handle_get_list_of_auxiliary_image_IDs (
    const(heif_image_handle)* handle,
    int aux_filter,
    heif_item_id* ids,
    int count);

// You are responsible to deallocate the returned buffer with heif_image_handle_free_auxiliary_types().
heif_error heif_image_handle_get_auxiliary_type (
    const(heif_image_handle)* handle,
    const(char*)* out_type);

void heif_image_handle_free_auxiliary_types (
    const(heif_image_handle)* handle,
    const(char*)* out_type);

// Get the image handle of an auxiliary image.
heif_error heif_image_handle_get_auxiliary_image_handle (
    const(heif_image_handle)* main_image_handle,
    heif_item_id auxiliary_id,
    heif_image_handle** out_auxiliary_handle);

// ------------------------- metadata (Exif / XMP) -------------------------

// How many metadata blocks are attached to an image. Usually, the only metadata is
// an "Exif" block.
int heif_image_handle_get_number_of_metadata_blocks (
    const(heif_image_handle)* handle,
    const(char)* type_filter);

// 'type_filter' can be used to get only metadata of specific types, like "Exif".
// If 'type_filter' is NULL, it will return all types of metadata IDs.
int heif_image_handle_get_list_of_metadata_block_IDs (
    const(heif_image_handle)* handle,
    const(char)* type_filter,
    heif_item_id* ids,
    int count);

// Return a string indicating the type of the metadata, as specified in the HEIF file.
// Exif data will have the type string "Exif".
// This string will be valid until the next call to a libheif function.
// You do not have to free this string.
const(char)* heif_image_handle_get_metadata_type (
    const(heif_image_handle)* handle,
    heif_item_id metadata_id);

const(char)* heif_image_handle_get_metadata_content_type (
    const(heif_image_handle)* handle,
    heif_item_id metadata_id);

// Get the size of the raw metadata, as stored in the HEIF file.
size_t heif_image_handle_get_metadata_size (
    const(heif_image_handle)* handle,
    heif_item_id metadata_id);

// 'out_data' must point to a memory area of the size reported by heif_image_handle_get_metadata_size().
// The data is returned exactly as stored in the HEIF file.
// For Exif data, you probably have to skip the first four bytes of the data, since they
// indicate the offset to the start of the TIFF header of the Exif data.
heif_error heif_image_handle_get_metadata (
    const(heif_image_handle)* handle,
    heif_item_id metadata_id,
    void* out_data);

enum heif_color_profile_type
{
    heif_color_profile_type_not_present = 0,
    heif_color_profile_type_nclx = heif_fourcc('n', 'c', 'l', 'x'),
    heif_color_profile_type_rICC = heif_fourcc('r', 'I', 'C', 'C'),
    heif_color_profile_type_prof = heif_fourcc('p', 'r', 'o', 'f')
}

// Returns 'heif_color_profile_type_not_present' if there is no color profile.
// If there is an ICC profile and an NCLX profile, the ICC profile is returned.
// TODO: we need a new API for this function as images can contain both NCLX and ICC at the same time.
//       However, you can still use heif_image_handle_get_raw_color_profile() and
//       heif_image_handle_get_nclx_color_profile() to access both profiles.
heif_color_profile_type heif_image_handle_get_color_profile_type (
    const(heif_image_handle)* handle);

size_t heif_image_handle_get_raw_color_profile_size (
    const(heif_image_handle)* handle);

// Returns 'heif_error_Color_profile_does_not_exist' when there is no ICC profile.
heif_error heif_image_handle_get_raw_color_profile (
    const(heif_image_handle)* handle,
    void* out_data);

enum heif_color_primaries
{
    heif_color_primaries_ITU_R_BT_709_5 = 1, // g=0.3;0.6, b=0.15;0.06, r=0.64;0.33, w=0.3127,0.3290
    heif_color_primaries_unspecified = 2,
    heif_color_primaries_ITU_R_BT_470_6_System_M = 4,
    heif_color_primaries_ITU_R_BT_470_6_System_B_G = 5,
    heif_color_primaries_ITU_R_BT_601_6 = 6,
    heif_color_primaries_SMPTE_240M = 7,
    heif_color_primaries_generic_film = 8,
    heif_color_primaries_ITU_R_BT_2020_2_and_2100_0 = 9,
    heif_color_primaries_SMPTE_ST_428_1 = 10,
    heif_color_primaries_SMPTE_RP_431_2 = 11,
    heif_color_primaries_SMPTE_EG_432_1 = 12,
    heif_color_primaries_EBU_Tech_3213_E = 22
}

enum heif_transfer_characteristics
{
    heif_transfer_characteristic_ITU_R_BT_709_5 = 1,
    heif_transfer_characteristic_unspecified = 2,
    heif_transfer_characteristic_ITU_R_BT_470_6_System_M = 4,
    heif_transfer_characteristic_ITU_R_BT_470_6_System_B_G = 5,
    heif_transfer_characteristic_ITU_R_BT_601_6 = 6,
    heif_transfer_characteristic_SMPTE_240M = 7,
    heif_transfer_characteristic_linear = 8,
    heif_transfer_characteristic_logarithmic_100 = 9,
    heif_transfer_characteristic_logarithmic_100_sqrt10 = 10,
    heif_transfer_characteristic_IEC_61966_2_4 = 11,
    heif_transfer_characteristic_ITU_R_BT_1361 = 12,
    heif_transfer_characteristic_IEC_61966_2_1 = 13,
    heif_transfer_characteristic_ITU_R_BT_2020_2_10bit = 14,
    heif_transfer_characteristic_ITU_R_BT_2020_2_12bit = 15,
    heif_transfer_characteristic_ITU_R_BT_2100_0_PQ = 16,
    heif_transfer_characteristic_SMPTE_ST_428_1 = 17,
    heif_transfer_characteristic_ITU_R_BT_2100_0_HLG = 18
}

enum heif_matrix_coefficients
{
    heif_matrix_coefficients_RGB_GBR = 0,
    heif_matrix_coefficients_ITU_R_BT_709_5 = 1, // TODO: or 709-6 according to h.273
    heif_matrix_coefficients_unspecified = 2,
    heif_matrix_coefficients_US_FCC_T47 = 4,
    heif_matrix_coefficients_ITU_R_BT_470_6_System_B_G = 5,
    heif_matrix_coefficients_ITU_R_BT_601_6 = 6, // TODO: or 601-7 according to h.273
    heif_matrix_coefficients_SMPTE_240M = 7,
    heif_matrix_coefficients_YCgCo = 8,
    heif_matrix_coefficients_ITU_R_BT_2020_2_non_constant_luminance = 9,
    heif_matrix_coefficients_ITU_R_BT_2020_2_constant_luminance = 10,
    heif_matrix_coefficients_SMPTE_ST_2085 = 11,
    heif_matrix_coefficients_chromaticity_derived_non_constant_luminance = 12,
    heif_matrix_coefficients_chromaticity_derived_constant_luminance = 13,
    heif_matrix_coefficients_ICtCp = 14
}

struct heif_color_profile_nclx
{
    // === version 1 fields

    ubyte version_;

    heif_color_primaries color_primaries;
    heif_transfer_characteristics transfer_characteristics;
    heif_matrix_coefficients matrix_coefficients;
    ubyte full_range_flag;

    // --- decoded values (not used when saving nclx)

    float color_primary_red_x;
    float color_primary_red_y;
    float color_primary_green_x;
    float color_primary_green_y;
    float color_primary_blue_x;
    float color_primary_blue_y;
    float color_primary_white_x;
    float color_primary_white_y;
}

// Returns 'heif_error_Color_profile_does_not_exist' when there is no NCLX profile.
// TODO: This function does currently not return an NCLX profile if it is stored in the image bitstream.
//       Only NCLX profiles stored as colr boxes are returned. This may change in the future.
heif_error heif_image_handle_get_nclx_color_profile (
    const(heif_image_handle)* handle,
    heif_color_profile_nclx** out_data);

// Returned color profile has 'version' field set to the maximum allowed.
// Do not fill values for higher versions as these might be outside the allocated structure size.
// May return NULL.
heif_color_profile_nclx* heif_nclx_color_profile_alloc ();

void heif_nclx_color_profile_free (heif_color_profile_nclx* nclx_profile);

heif_color_profile_type heif_image_get_color_profile_type (
    const(heif_image)* image);

size_t heif_image_get_raw_color_profile_size (const(heif_image)* image);

heif_error heif_image_get_raw_color_profile (
    const(heif_image)* image,
    void* out_data);

heif_error heif_image_get_nclx_color_profile (
    const(heif_image)* image,
    heif_color_profile_nclx** out_data);

// ========================= heif_image =========================

// An heif_image contains a decoded pixel image in various colorspaces, chroma formats,
// and bit depths.

// Note: when converting images to an interleaved chroma format, the resulting
// image contains only a single channel of type channel_interleaved with, e.g., 3 bytes per pixel,
// containing the interleaved R,G,B values.

// Planar RGB images are specified as heif_colorspace_RGB / heif_chroma_444.

enum heif_compression_format
{
    heif_compression_undefined = 0,
    heif_compression_HEVC = 1,
    heif_compression_AVC = 2,
    heif_compression_JPEG = 3,
    heif_compression_AV1 = 4
}

enum heif_chroma
{
    heif_chroma_undefined = 99,
    heif_chroma_monochrome = 0,
    heif_chroma_420 = 1,
    heif_chroma_422 = 2,
    heif_chroma_444 = 3,
    heif_chroma_interleaved_RGB = 10,
    heif_chroma_interleaved_RGBA = 11,
    heif_chroma_interleaved_RRGGBB_BE = 12,
    heif_chroma_interleaved_RRGGBBAA_BE = 13,
    heif_chroma_interleaved_RRGGBB_LE = 14,
    heif_chroma_interleaved_RRGGBBAA_LE = 15
}

// DEPRECATED ENUM NAMES
enum heif_chroma_interleaved_24bit = heif_chroma.heif_chroma_interleaved_RGB;
enum heif_chroma_interleaved_32bit = heif_chroma.heif_chroma_interleaved_RGBA;

enum heif_colorspace
{
    heif_colorspace_undefined = 99,
    heif_colorspace_YCbCr = 0,
    heif_colorspace_RGB = 1,
    heif_colorspace_monochrome = 2
}

enum heif_channel
{
    heif_channel_Y = 0,
    heif_channel_Cb = 1,
    heif_channel_Cr = 2,
    heif_channel_R = 3,
    heif_channel_G = 4,
    heif_channel_B = 5,
    heif_channel_Alpha = 6,
    heif_channel_interleaved = 10
}

enum heif_progress_step
{
    heif_progress_step_total = 0,
    heif_progress_step_load_tile = 1
}

struct heif_decoding_options
{
    ubyte version_;

    // version 1 options

    // Ignore geometric transformations like cropping, rotation, mirroring.
    // Default: false (do not ignore).
    ubyte ignore_transformations;

    void function (heif_progress_step step, int max_progress, void* progress_user_data) start_progress;

    void function (heif_progress_step step, int progress, void* progress_user_data) on_progress;

    void function (heif_progress_step step, void* progress_user_data) end_progress;

    void* progress_user_data;

    // version 2 options

    ubyte convert_hdr_to_8bit;
}

// Allocate decoding options and fill with default values.
// Note: you should always get the decoding options through this function since the
// option structure may grow in size in future versions.
heif_decoding_options* heif_decoding_options_alloc ();

void heif_decoding_options_free (heif_decoding_options*);

// Decode an heif_image_handle into the actual pixel image and also carry out
// all geometric transformations specified in the HEIF file (rotation, cropping, mirroring).
//
// If colorspace or chroma is set to heif_colorspace_undefined or heif_chroma_undefined,
// respectively, the original colorspace is taken.
// Decoding options may be NULL. If you want to supply options, always use
// heif_decoding_options_alloc() to get the structure.
heif_error heif_decode_image (
    const(heif_image_handle)* in_handle,
    heif_image** out_img,
    heif_colorspace colorspace,
    heif_chroma chroma,
    const(heif_decoding_options)* options);

// Get the colorspace format of the image.
heif_colorspace heif_image_get_colorspace (const(heif_image)*);

// Get the chroma format of the image.
heif_chroma heif_image_get_chroma_format (const(heif_image)*);

// Get width of the given image channel in pixels. Returns -1 if a non-existing
// channel was given.
int heif_image_get_width (const(heif_image)*, heif_channel channel);

// Get height of the given image channel in pixels. Returns -1 if a non-existing
// channel was given.
int heif_image_get_height (const(heif_image)*, heif_channel channel);

// Get the width of the main channel (Y in YCbCr, or any in RGB).
int heif_image_get_primary_width (const(heif_image)*);

int heif_image_get_primary_height (const(heif_image)*);

heif_error heif_image_crop (
    heif_image* img,
    int left,
    int right,
    int top,
    int bottom);

// Get the number of bits per pixel in the given image channel. Returns -1 if
// a non-existing channel was given.
// Note that the number of bits per pixel may be different for each color channel.
// This function returns the number of bits used for storage of each pixel.
// Especially for HDR images, this is probably not what you want. Have a look at
// heif_image_get_bits_per_pixel_range() instead.
int heif_image_get_bits_per_pixel (const(heif_image)*, heif_channel channel);

// Get the number of bits per pixel in the given image channel. This function returns
// the number of bits used for representing the pixel value, which might be smaller
// than the number of bits used in memory.
// For example, in 12bit HDR images, this function returns '12', while still 16 bits
// are reserved for storage. For interleaved RGBA with 12 bit, this function also returns
// '12', not '48' or '64' (heif_image_get_bits_per_pixel returns 64 in this case).
int heif_image_get_bits_per_pixel_range (
    const(heif_image)*,
    heif_channel channel);

int heif_image_has_channel (const(heif_image)*, heif_channel channel);

// Get a pointer to the actual pixel data.
// The 'out_stride' is returned as "bytes per line".
// When out_stride is NULL, no value will be written.
// Returns NULL if a non-existing channel was given.
const(ubyte)* heif_image_get_plane_readonly (
    const(heif_image)*,
    heif_channel channel,
    int* out_stride);

ubyte* heif_image_get_plane (
    heif_image*,
    heif_channel channel,
    int* out_stride);

struct heif_scaling_options;

// Currently, heif_scaling_options is not defined yet. Pass a NULL pointer.
heif_error heif_image_scale_image (
    const(heif_image)* input,
    heif_image** output,
    int width,
    int height,
    const(heif_scaling_options)* options);

// The color profile is not attached to the image handle because we might need it
// for color space transform and encoding.
heif_error heif_image_set_raw_color_profile (
    heif_image* image,
    const(char)* profile_type_fourcc_string,
    const(void)* profile_data,
    const size_t profile_size);

heif_error heif_image_set_nclx_color_profile (
    heif_image* image,
    const(heif_color_profile_nclx)* color_profile);

// TODO: this function does not make any sense yet, since we currently cannot modify existing HEIF files.
//LIBHEIF_API
//void heif_image_remove_color_profile(struct heif_image* image);

// Release heif_image.
void heif_image_release (const(heif_image)*);

// ====================================================================================================
//  Encoding API

heif_error heif_context_write_to_file (heif_context*, const(char)* filename);

struct heif_writer
{
    // API version supported by this writer
    int writer_api_version;

    // --- version 1 functions ---
    // TODO: why do we need this parameter?
    heif_error function (
        heif_context* ctx,
        const(void)* data,
        size_t size,
        void* userdata) write;
}

heif_error heif_context_write (
    heif_context*,
    heif_writer* writer,
    void* userdata);

// ----- encoder -----

// The encoder used for actually encoding an image.
struct heif_encoder;

// A description of the encoder's capabilities and name.
struct heif_encoder_descriptor;

// A configuration parameter of the encoder. Each encoder implementation may have a different
// set of parameters. For the most common settings (e.q. quality), special functions to set
// the parameters are provided.
struct heif_encoder_parameter;

// Get a list of available encoders. You can filter the encoders by compression format and name.
// Use format_filter==heif_compression_undefined and name_filter==NULL as wildcards.
// The returned list of encoders is sorted by their priority (which is a plugin property).
// Note: to get the actual encoder from the descriptors returned here, use heif_context_get_encoder().
// TODO: why do we need this parameter?
int heif_context_get_encoder_descriptors (
    heif_context*,
    heif_compression_format format_filter,
    const(char)* name_filter,
    const(heif_encoder_descriptor*)* out_encoders,
    int count);

// Return a long, descriptive name of the encoder (including version information).
const(char)* heif_encoder_descriptor_get_name (const(heif_encoder_descriptor)*);

// Return a short, symbolic name for identifying the encoder.
// This name should stay constant over different encoder versions.
const(char)* heif_encoder_descriptor_get_id_name (
    const(heif_encoder_descriptor)*);

heif_compression_format heif_encoder_descriptor_get_compression_format (
    const(heif_encoder_descriptor)*);

int heif_encoder_descriptor_supports_lossy_compression (
    const(heif_encoder_descriptor)*);

int heif_encoder_descriptor_supports_lossless_compression (
    const(heif_encoder_descriptor)*);

// Get an encoder instance that can be used to actually encode images from a descriptor.
heif_error heif_context_get_encoder (
    heif_context* context,
    const(heif_encoder_descriptor)*,
    heif_encoder** out_encoder);

// Quick check whether there is a decoder available for the given format.
// Note that the decoder still may not be able to decode all variants of that format.
// You will have to query that further (todo) or just try to decode and check the returned error.
int heif_have_decoder_for_format (heif_compression_format format);

// Quick check whether there is an enoder available for the given format.
// Note that the encoder may be limited to a certain subset of features (e.g. only 8 bit, only lossy).
// You will have to query the specific capabilities further.
int heif_have_encoder_for_format (heif_compression_format format);

// Get an encoder for the given compression format. If there are several encoder plugins
// for this format, the encoder with the highest plugin priority will be returned.
heif_error heif_context_get_encoder_for_format (
    heif_context* context,
    heif_compression_format format,
    heif_encoder**);

// You have to release the encoder after use.
void heif_encoder_release (heif_encoder*);

// Get the encoder name from the encoder itself.
const(char)* heif_encoder_get_name (const(heif_encoder)*);

// --- Encoder Parameters ---

// Libheif supports settings parameters through specialized functions and through
// generic functions by parameter name. Sometimes, the same parameter can be set
// in both ways.
// We consider it best practice to use the generic parameter functions only in
// dynamically generated user interfaces, as no guarantees are made that some specific
// parameter names are supported by all plugins.

// Set a 'quality' factor (0-100). How this is mapped to actual encoding parameters is
// encoder dependent.
heif_error heif_encoder_set_lossy_quality (heif_encoder*, int quality);

heif_error heif_encoder_set_lossless (heif_encoder*, int enable);

// level should be between 0 (= none) to 4 (= full)
heif_error heif_encoder_set_logging_level (heif_encoder*, int level);

// Get a generic list of encoder parameters.
// Each encoder may define its own, additional set of parameters.
// You do not have to free the returned list.
const(heif_encoder_parameter*)* heif_encoder_list_parameters (heif_encoder*);

// Return the parameter name.
const(char)* heif_encoder_parameter_get_name (const(heif_encoder_parameter)*);

enum heif_encoder_parameter_type
{
    heif_encoder_parameter_type_integer = 1,
    heif_encoder_parameter_type_boolean = 2,
    heif_encoder_parameter_type_string = 3
}

// Return the parameter type.
heif_encoder_parameter_type heif_encoder_parameter_get_type (
    const(heif_encoder_parameter)*);

// DEPRECATED. Use heif_encoder_parameter_get_valid_integer_values() instead.
heif_error heif_encoder_parameter_get_valid_integer_range (
    const(heif_encoder_parameter)*,
    int* have_minimum_maximum,
    int* minimum,
    int* maximum);

// If integer is limited by a range, have_minimum and/or have_maximum will be != 0 and *minimum, *maximum is set.
// If integer is limited by a fixed set of values, *num_valid_values will be >0 and *out_integer_array is set.
heif_error heif_encoder_parameter_get_valid_integer_values (
    const(heif_encoder_parameter)*,
    int* have_minimum,
    int* have_maximum,
    int* minimum,
    int* maximum,
    int* num_valid_values,
    const(int*)* out_integer_array);

heif_error heif_encoder_parameter_get_valid_string_values (
    const(heif_encoder_parameter)*,
    const(char**)* out_stringarray);

heif_error heif_encoder_set_parameter_integer (
    heif_encoder*,
    const(char)* parameter_name,
    int value);

heif_error heif_encoder_get_parameter_integer (
    heif_encoder*,
    const(char)* parameter_name,
    int* value);

// TODO: name should be changed to heif_encoder_get_valid_integer_parameter_range // DEPRECATED.
heif_error heif_encoder_parameter_integer_valid_range (
    heif_encoder*,
    const(char)* parameter_name,
    int* have_minimum_maximum,
    int* minimum,
    int* maximum);

heif_error heif_encoder_set_parameter_boolean (
    heif_encoder*,
    const(char)* parameter_name,
    int value);

heif_error heif_encoder_get_parameter_boolean (
    heif_encoder*,
    const(char)* parameter_name,
    int* value);

heif_error heif_encoder_set_parameter_string (
    heif_encoder*,
    const(char)* parameter_name,
    const(char)* value);

heif_error heif_encoder_get_parameter_string (
    heif_encoder*,
    const(char)* parameter_name,
    char* value,
    int value_size);

// returns a NULL-terminated list of valid strings or NULL if all values are allowed
heif_error heif_encoder_parameter_string_valid_values (
    heif_encoder*,
    const(char)* parameter_name,
    const(char**)* out_stringarray);

heif_error heif_encoder_parameter_integer_valid_values (
    heif_encoder*,
    const(char)* parameter_name,
    int* have_minimum,
    int* have_maximum,
    int* minimum,
    int* maximum,
    int* num_valid_values,
    const(int*)* out_integer_array);

// Set a parameter of any type to the string value.
// Integer values are parsed from the string.
// Boolean values can be "true"/"false"/"1"/"0"
//
// x265 encoder specific note:
// When using the x265 encoder, you may pass any of its parameters by
// prefixing the parameter name with 'x265:'. Hence, to set the 'ctu' parameter,
// you will have to set 'x265:ctu' in libheif.
// Note that there is no checking for valid parameters when using the prefix.
heif_error heif_encoder_set_parameter (
    heif_encoder*,
    const(char)* parameter_name,
    const(char)* value);

// Get the current value of a parameter of any type as a human readable string.
// The returned string is compatible with heif_encoder_set_parameter().
heif_error heif_encoder_get_parameter (
    heif_encoder*,
    const(char)* parameter_name,
    char* value_ptr,
    int value_size);

// Query whether a specific parameter has a default value.
int heif_encoder_has_default (heif_encoder*, const(char)* parameter_name);

struct heif_encoding_options
{
    ubyte version_;

    // version 1 options

    ubyte save_alpha_channel; // default: true

    // version 2 options

    // Crops heif images with a grid wrapper instead of a 'clap' transform.
    // Results in slightly larger file size.
    // Default: on.
    ubyte macOS_compatibility_workaround;

    // version 3 options

    ubyte save_two_colr_boxes_when_ICC_and_nclx_available; // default: false

    // version 4 options

    // Set this to the NCLX parameters to be used in the output image or set to NULL
    // when the same parameters as in the input image should be used.
    heif_color_profile_nclx* output_nclx_profile;

    ubyte macOS_compatibility_workaround_no_nclx_profile;
}

heif_encoding_options* heif_encoding_options_alloc ();

void heif_encoding_options_free (heif_encoding_options*);

// Compress the input image.
// Returns a handle to the coded image in 'out_image_handle' unless out_image_handle = NULL.
// 'options' should be NULL for now.
// The first image added to the context is also automatically set the primary image, but
// you can change the primary image later with heif_context_set_primary_image().
heif_error heif_context_encode_image (
    heif_context*,
    const(heif_image)* image,
    heif_encoder* encoder,
    const(heif_encoding_options)* options,
    heif_image_handle** out_image_handle);

heif_error heif_context_set_primary_image (
    heif_context*,
    heif_image_handle* image_handle);

// Encode the 'image' as a scaled down thumbnail image.
// The image is scaled down to fit into a square area of width 'bbox_size'.
// If the input image is already so small that it fits into this bounding box, no thumbnail
// image is encoded and NULL is returned in 'out_thumb_image_handle'.
// No error is returned in this case.
// The encoded thumbnail is automatically assigned to the 'master_image_handle'. Hence, you
// do not have to call heif_context_assign_thumbnail().
heif_error heif_context_encode_thumbnail (
    heif_context*,
    const(heif_image)* image,
    const(heif_image_handle)* master_image_handle,
    heif_encoder* encoder,
    const(heif_encoding_options)* options,
    int bbox_size,
    heif_image_handle** out_thumb_image_handle);

// Assign 'thumbnail_image' as the thumbnail image of 'master_image'.
heif_error heif_context_assign_thumbnail (
    heif_context*,
    const(heif_image_handle)* master_image,
    const(heif_image_handle)* thumbnail_image);

// Add EXIF metadata to an image.
heif_error heif_context_add_exif_metadata (
    heif_context*,
    const(heif_image_handle)* image_handle,
    const(void)* data,
    int size);

// Add XMP metadata to an image.
heif_error heif_context_add_XMP_metadata (
    heif_context*,
    const(heif_image_handle)* image_handle,
    const(void)* data,
    int size);

// Add generic, proprietary metadata to an image. You have to specify an 'item_type' that will
// identify your metadata. 'content_type' can be an additional type, or it can be NULL.
// For example, this function can be used to add IPTC metadata (IIM stream, not XMP) to an image.
// Even not standard, we propose to store IPTC data with item type="iptc", content_type=NULL.
heif_error heif_context_add_generic_metadata (
    heif_context* ctx,
    const(heif_image_handle)* image_handle,
    const(void)* data,
    int size,
    const(char)* item_type,
    const(char)* content_type);

// --- heif_image allocation

// Create a new image of the specified resolution and colorspace.
// Note: no memory for the actual image data is reserved yet. You have to use
// heif_image_add_plane() to add the image planes required by your colorspace/chroma.
heif_error heif_image_create (
    int width,
    int height,
    heif_colorspace colorspace,
    heif_chroma chroma,
    heif_image** out_image);

// The indicated bit_depth corresponds to the bit depth per channel.
// I.e. for interleaved formats like RRGGBB, the bit_depth would be, e.g., 10 bit instead
// of 30 bits or 3*16=48 bits.
// For backward compatibility, one can also specify 24bits for RGB and 32bits for RGBA,
// instead of the preferred 8 bits.
heif_error heif_image_add_plane (
    heif_image* image,
    heif_channel channel,
    int width,
    int height,
    int bit_depth);

// Signal that the image is premultiplied by the alpha pixel values.
void heif_image_set_premultiplied_alpha (
    heif_image* image,
    int is_premultiplied_alpha);

int heif_image_is_premultiplied_alpha (heif_image* image);

// --- register plugins

struct heif_decoder_plugin;
struct heif_encoder_plugin;

// DEPRECATED. Use heif_register_decoder_plugin(const struct heif_decoder_plugin*) instead.
heif_error heif_register_decoder (
    heif_context* heif,
    const(heif_decoder_plugin)*);

heif_error heif_register_decoder_plugin (const(heif_decoder_plugin)*);

heif_error heif_register_encoder_plugin (const(heif_encoder_plugin)*);

// DEPRECATED, typo in function name
int heif_encoder_descriptor_supportes_lossy_compression (
    const(heif_encoder_descriptor)*);

// DEPRECATED, typo in function name
int heif_encoder_descriptor_supportes_lossless_compression (
    const(heif_encoder_descriptor)*);

