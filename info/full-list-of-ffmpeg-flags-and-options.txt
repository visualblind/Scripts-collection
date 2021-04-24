Originall From: Posted 2015-05-29 http://ubwg.net/b/full-list-of-ffmpeg-flags-and-options

This is the complete list that’s outputted by ffmpeg when running ffmpeg -h full.

usage: ffmpeg [options] [[infile options] -i infile]… {[outfile options] outfile}…

Getting help:
    -h — print basic options
    -h long — print more options
    -h full — print all options (including all format and codec specific options, very long)
    See man ffmpeg for detailed description of the options.

Print help / information / capabilities:
-L show license
-h topic show help
-? topic show help
-help topic show help
—help topic show help
-version show version
-buildconf show build configuration
-formats show available formats
-codecs show available codecs
-decoders show available decoders
-encoders show available encoders
-bsfs show available bit stream filters
-protocols show available protocols
-filters show available filters
-pix_fmts show available pixel formats
-layouts show standard channel layouts
-sample_fmts show available audio sample formats
-colors show available color names

Global options (affect whole program instead of just one file):
-loglevel loglevel set logging level
-v loglevel set logging level
-report generate a report
-max_alloc bytes set maximum size of a single allocated block
-y overwrite output files
-n never overwrite output files
-stats print progress report during encoding
-max_error_rate ratio of errors (0.0: no errors, 1.0: 100% error maximum error rate
-bits_per_raw_sample number set the number of bits per raw sample
-vol volume change audio volume (256=normal)

Advanced global options:
-cpuflags flags force specific cpu flags
-hide_banner hide_banner do not show program banner
-benchmark add timings for benchmarking
-benchmark_all add timings for each task
-progress url write program-readable progress information
-stdin enable or disable interaction on standard input
-timelimit limit set max runtime in seconds
-dump dump each input packet
-hex when dumping packets, also dump the payload
-vsync video sync method
-async audio sync method
-adrift_threshold threshold audio drift threshold
-copyts copy timestamps
-copytb mode copy input stream time base when stream copying
-dts_delta_threshold threshold timestamp discontinuity delta threshold
-dts_error_threshold threshold timestamp error delta threshold
-xerror error exit on error
-filter_complex graph_description create a complex filtergraph
-lavfi graph_description create a complex filtergraph
-filter_complex_script filename read complex filtergraph description from a file
-debug_ts print timestamp debugging info
-intra deprecated use -g 1
-vdt n discard threshold
-sameq Removed
-same_quant Removed
-deinterlace this option is deprecated, use the yadif filter instead
-psnr calculate PSNR of compressed frames
-vstats dump video coding statistics to file
-vstats_file file dump video coding statistics to file
-dc precision intra_dc_precision
-qphist show QP histogram
-vc channel deprecated, use -channel
-tvstd standard deprecated, use -standard
-isync this option is deprecated and does nothing
-override_ffserver override the options from ffserver

Per-file main options:
-f fmt force format
-c codec codec name
-codec codec codec name
-pre preset preset name
-map_metadata outfile[,metadata]:infile[,metadata] set metadata information of outfile from infile
-t duration record or transcode “duration” seconds of audio/video
-to time_stop record or transcode stop time
-fs limit_size set the limit file size in bytes
-ss time_off set the start time offset
-timestamp time set the recording timestamp (‘now’ to set the current time)
-metadata string=string add metadata
-target type specify target file type (“vcd”, “svcd”, “dvd”, “dv”, “dv50”, “pal-vcd”, “ntsc-svcd”, …)
-apad audio pad
-frames number set the number of frames to record
-filter filter_graph set stream filtergraph
-filter_script filename read stream filtergraph description from a file
-reinit_filter reinit filtergraph on input parameter changes

Advanced per-file options:
-map [-]input_file_id[:stream_specifier][,sync_file_id[:stream_s set input stream mapping
-map_channel file.stream.channel[:syncfile.syncstream] map an audio channel from one stream to another
-map_chapters input_file_index set chapters mapping
-accurate_seek enable/disable accurate seeking with -ss
-itsoffset time_off set the input ts offset
-itsscale scale set the input ts scale
-dframes number set the number of data frames to record
-re read input at native frame rate
-shortest finish encoding within shortest input
-copyinkf copy initial non-keyframes
-copypriorss copy or discard frames before start time
-tag fourcc/tag force codec tag/fourcc
-q q use fixed quality scale (VBR)
-qscale q use fixed quality scale (VBR)
-profile profile set profile
-attach filename add an attachment to the output file
-dump_attachment filename extract an attachment into a file
-muxdelay seconds set the maximum demux-decode delay
-muxpreload seconds set the initial demux-decode delay
-bsf bitstream_filters A comma-separated list of bitstream filters
-fpre filename set options from indicated preset file
-dcodec codec force data codec (‘copy’ to copy stream)

Video options:
-vframes number set the number of video frames to record
-r rate set frame rate (Hz value, fraction or abbreviation)
-s size set frame size (WxH or abbreviation)
-aspect aspect set aspect ratio (4:3, 16:9 or 1.3333, 1.7777)
-bits_per_raw_sample number set the number of bits per raw sample
-vn disable video
-vcodec codec force video codec (‘copy’ to copy stream)
-timecode hh:mm:ss[:;.]ff set initial TimeCode value.
-pass n select the pass number (1 to 3)
-vf filter_graph set video filters
-b bitrate video bitrate (please use -b:v)
-dn disable data

Advanced Video options:
-pix_fmt format set pixel format
-intra deprecated use -g 1
-vdt n discard threshold
-rc_override override rate control override for specific intervals
-sameq Removed
-same_quant Removed
-passlogfile prefix select two pass log file name prefix
-deinterlace this option is deprecated, use the yadif filter instead
-psnr calculate PSNR of compressed frames
-vstats dump video coding statistics to file
-vstats_file file dump video coding statistics to file
-intra_matrix matrix specify intra matrix coeffs
-inter_matrix matrix specify inter matrix coeffs
-chroma_intra_matrix matrix specify intra matrix coeffs
-top top=1/bottom=0/auto=-1 field first
-dc precision intra_dc_precision
-vtag fourcc/tag force video tag/fourcc
-qphist show QP histogram
-force_fps force the selected framerate, disable the best supported framerate selection
-streamid streamIndex:value set the value of an outfile streamid
-force_key_frames timestamps force key frames at specified timestamps
-hwaccel hwaccel name use HW accelerated decoding
-hwaccel_device select a device for HW accelerationdevicename
-vc channel deprecated, use -channel
-tvstd standard deprecated, use -standard
-vbsf video bitstream_filters deprecated
-vpre preset set the video options to the indicated preset

Audio options:
-aframes number set the number of audio frames to record
-aq quality set audio quality (codec-specific)
-ar rate set audio sampling rate (in Hz)
-ac channels set number of audio channels
-an disable audio
-acodec codec force audio codec (‘copy’ to copy stream)
-vol volume change audio volume (256=normal)
-af filter_graph set audio filters

Advanced Audio options:
-atag fourcc/tag force audio tag/fourcc
-sample_fmt format set sample format
-channel_layout layout set channel layout
-guess_layout_max set the maximum number of channels to try to guess the channel layout
-absf audio bitstream_filters deprecated
-apre preset set the audio options to the indicated preset

Subtitle options:
-s size set frame size (WxH or abbreviation)
-sn disable subtitle
-scodec codec force subtitle codec (‘copy’ to copy stream)
-stag fourcc/tag force subtitle tag/fourcc
-fix_sub_duration fix subtitles duration
-canvas_size size set canvas size (WxH or abbreviation)
-spre preset set the subtitle options to the indicated preset

AVCodecContext AVOptions:
-b E..VA… set bitrate (in bits/s) (from 0 to INT_MAX) (default 200000)
-ab E…A… set bitrate (in bits/s) (from 0 to INT_MAX) (default 128000)
-bt E..V…. Set video bitrate tolerance (in bits/s). In 1-pass mode, bitrate tolerance specifies how far ratecontrol is willing to deviate from the target average bitrate value. This is not related to minimum/maximum bitrate. Lowering tolerance too much has an adverse effect on quality. (from 1 to INT_MAX) (default 4e+006)
-flags ED.VAS.. (default 0)
     unaligned .D.V…. allow decoders to produce unaligned output
     mv4 E..V…. use four motion vectors per macroblock (MPEG-4)
     qpel E..V…. use 1/4-pel motion compensation
     loop E..V…. use loop filter
     gmc E..V…. use gmc
     mv0 E..V…. always try a mb with mv=<0,0>
     gray ED.V…. only decode/encode grayscale
     psnr E..V…. error[?] variables will be set during encoding
     naq E..V…. normalize adaptive quantization
     ildct E..V…. use interlaced DCT
     low_delay ED.V…. force low delay
     global_header E..VA… place global headers in extradata instead of every keyframe
     bitexact ED.VAS.. use only bitexact functions (except (I)DCT)
     aic E..V…. H.263 advanced intra coding / MPEG-4 AC prediction
     ilme E..V…. interlaced motion estimation
     cgop E..V…. closed GOP
     output_corrupt .D.V…. Output even potentially corrupted frames
  -me_method E..V…. set motion estimation method (from INT_MIN to INT_MAX) (default 5)
     zero E..V…. zero motion estimation (fastest)
     full E..V…. full motion estimation (slowest)
     epzs E..V…. EPZS motion estimation (default)
     esa E..V…. esa motion estimation (alias for full)
     tesa E..V…. tesa motion estimation
     dia E..V…. diamond motion estimation (alias for EPZS)
     log E..V…. log motion estimation
     phods E..V…. phods motion estimation
     x1 E..V…. X1 motion estimation
     hex E..V…. hex motion estimation
     umh E..V…. umh motion estimation
     iter E..V…. iter motion estimation
  -g E..V…. set the group of picture (GOP) size (from INT_MIN to INT_MAX) (default 12)
  -ar ED..A… set audio sampling rate (in Hz) (from INT_MIN to INT_MAX) (default 0)
  -ac ED..A… set number of audio channels (from INT_MIN to INT_MAX) (default 0)
  -cutoff E…A… set cutoff bandwidth (from INT_MIN to INT_MAX) (default 0)
  -frame_size E…A… (from INT_MIN to INT_MAX) (default 0)
  -qcomp E..V…. video quantizer scale compression (VBR). Constant of ratecontrol equation. Recommended range for default rc_eq: 0.0-1.0 (from -FLT_MAX to FLT_MAX) (default 0.5)
  -qblur E..V…. video quantizer scale blur (VBR) (from -1 to FLT_MAX) (default 0.5)
  -qmin E..V…. minimum video quantizer scale (VBR) (from -1 to 69) (default 2)
  -qmax E..V…. maximum video quantizer scale (VBR) (from -1 to 1024) (default 31)
  -qdiff E..V…. maximum difference between the quantizer scales (VBR) (from INT_MIN to INT_MAX) (default 3)
  -bf E..V…. set maximum number of B frames between non-B-frames (from -1 to INT_MAX) (default 0)
  b_qfactor E..V…. QP factor between P and B-frames (from -FLT_MAX to FLT_MAX) (default 1.25)
  -rc_strategy E..V…. ratecontrol method (from INT_MIN to INT_MAX) (default 0)
  -b_strategy E..V…. strategy to choose between I/P/B-frames (from INT_MIN to INT_MAX) (default 0)
  -ps E..V…. RTP payload size in bytes (from INT_MIN to INT_MAX) (default 0)
  -bug .D.V…. work around not autodetected encoder bugs (default 1)
     autodetect .D.V….
     old_msmpeg4 .D.V…. some old lavc-generated MSMPEG4v3 files (no autodetection)
     xvid_ilace .D.V…. Xvid interlacing bug (autodetected if FOURCC XVIX)      ump4 .D.V.... (autodetected if FOURCC UMP4)
     no_padding .D.V…. padding bug (autodetected)
     amv .D.V….
     ac_vlc .D.V…. illegal VLC bug (autodetected per FOURCC)
     qpel_chroma .D.V….
     std_qpel .D.V…. old standard qpel (autodetected per FOURCC/version)
     qpel_chroma2 .D.V….
     direct_blocksize .D.V…. direct-qpel-blocksize bug (autodetected per FOURCC/version)
     edge .D.V…. edge padding bug (autodetected per FOURCC/version)
     hpel_chroma .D.V….
     dc_clip .D.V….
     ms .D.V…. work around various bugs in Microsoft’s broken decoders
     trunc .D.V…. truncated frames
  -strict ED.VA… how strictly to follow the standards (from INT_MIN to INT_MAX) (default 0)
     very ED.V…. strictly conform to a older more strict version of the spec or reference software
     strict ED.V…. strictly conform to all the things in the spec no matter what the consequences
     normal ED.V….
     unofficial ED.V…. allow unofficial extensions
     experimental ED.V…. allow non-standardized experimental things
  b_qoffset E..V…. QP offset between P and B-frames (from -FLT_MAX to FLT_MAX) (default 1.25)
  -err_detect .D.VA… set error detection flags (default 0)
     crccheck .D.VA… verify embedded CRCs
     bitstream .D.VA… detect bitstream specification deviations
     buffer .D.VA… detect improper bitstream length
     explode .D.VA… abort decoding on minor error detection
     careful .D.VA… consider things that violate the spec, are fast to check and have not been seen in the wild as errors
     compliant .D.VA… consider all spec non compliancies as errors
     aggressive .D.VA… consider things that a sane encoder should not do as an error
  -mpeg_quant E..V…. use MPEG quantizers instead of H.263 (from INT_MIN to INT_MAX) (default 0)
  -qsquish E..V…. how to keep quantizer between qmin and qmax (0 = clip, 1 = use differentiable function) (from 0 to 99) (default 0)
  -rc_qmod_amp E..V…. experimental quantizer modulation (from -FLT_MAX to FLT_MAX) (default 0)
  -rc_qmod_freq E..V…. experimental quantizer modulation (from INT_MIN to INT_MAX) (default 0)
  -rc_eq E..V…. Set rate control equation. When computing the expression, besides the standard functions defined in the section ‘Expression Evaluation’, the following functions are available: bits2qp(bits), qp2bits(qp). Also the following constants are available: iTex pTex tex mv fCode iCount mcVar var isI isP isB avgQP qComp avgIITex avgPITex avgPPTex avgBPTex avgTex.
  -maxrate E..VA… Set maximum bitrate tolerance (in bits/s). Requires bufsize to be set. (from INT_MIN to INT_MAX) (default 0)
  -minrate E..VA… Set minimum bitrate tolerance (in bits/s). Most useful in setting up a CBR encode. It is of little use otherwise. (from INT_MIN to INT_MAX) (default 0)
  -bufsize E..VA… set ratecontrol buffer size (in bits) (from INT_MIN to INT_MAX) (default 0)
  -rc_buf_aggressivity E..V…. currently useless (from -FLT_MAX to FLT_MAX) (default 1)
  i_qfactor E..V…. QP factor between P and I-frames (from -FLT_MAX to FLT_MAX) (default -0.8)
  i_qoffset E..V…. QP offset between P and I-frames (from -FLT_MAX to FLT_MAX) (default 0)
  -rc_init_cplx E..V…. initial complexity for 1-pass encoding (from -FLT_MAX to FLT_MAX) (default 0)
  -dct E..V…. DCT algorithm (from 0 to INT_MAX) (default 0)
     auto E..V…. autoselect a good one (default)
     fastint E..V…. fast integer
     int E..V…. accurate integer
     mmx E..V….
     altivec E..V….
     faan E..V…. floating point AAN DCT
  -lumi_mask E..V…. compresses bright areas stronger than medium ones (from -FLT_MAX to FLT_MAX) (default 0)
  -tcplx_mask E..V…. temporal complexity masking (from -FLT_MAX to FLT_MAX) (default 0)
  -scplx_mask E..V…. spatial complexity masking (from -FLT_MAX to FLT_MAX) (default 0)
  -p_mask E..V…. inter masking (from -FLT_MAX to FLT_MAX) (default 0)
  -dark_mask E..V…. compresses dark areas stronger than medium ones (from -FLT_MAX to FLT_MAX) (default 0)
  -idct ED.V…. select IDCT implementation (from 0 to INT_MAX) (default 0)
     auto ED.V….
     int ED.V….
     simple ED.V….
     simplemmx ED.V….
     arm ED.V….
     altivec ED.V….
     sh4 ED.V….
     simplearm ED.V….
     simplearmv5te ED.V….
     simplearmv6 ED.V….
     simpleneon ED.V….
     simplealpha ED.V….
     ipp ED.V….
     xvidmmx ED.V….
     faani ED.V…. floating point AAN IDCT
  -ec .D.V…. set error concealment strategy (default 3)
     guess_mvs .D.V…. iterative motion vector (MV) search (slow)
     deblock .D.V…. use strong deblock filter for damaged MBs
  -pred E..V…. prediction method (from INT_MIN to INT_MAX) (default 0)
     left E..V….
     plane E..V….
     median E..V….
  -aspect E..V…. sample aspect ratio (from 0 to 10) (default 0/1)
  -debug ED.VAS.. print specific debug info (default 0)
     pict .D.V…. picture info
     rc E..V…. rate control
     bitstream .D.V….
     mb_type .D.V…. macroblock (MB) type
     qp .D.V…. per-block quantization parameter (QP)
     mv .D.V…. motion vector
     dct_coeff .D.V….
     skip .D.V….
     startcode .D.V….
     pts .D.V….
     er .D.V…. error recognition
     mmco .D.V…. memory management control operations (H.264)
     bugs .D.V….
     vis_qp .D.V…. visualize quantization parameter (QP), lower QP are tinted greener
     vis_mb_type .D.V…. visualize block types
     buffers .D.V…. picture buffer allocations
     thread_ops .D.VA… threading operations
  -vismv .D.V…. visualize motion vectors (MVs) (from 0 to INT_MAX) (default 0)
     pf .D.V…. forward predicted MVs of P-frames
     bf .D.V…. forward predicted MVs of B-frames
     bb .D.V…. backward predicted MVs of B-frames
  -cmp E..V…. full-pel ME compare function (from INT_MIN to INT_MAX) (default 0)
     sad E..V…. sum of absolute differences, fast (default)
     sse E..V…. sum of squared errors
     satd E..V…. sum of absolute Hadamard transformed differences
     dct E..V…. sum of absolute DCT transformed differences
     psnr E..V…. sum of squared quantization errors (avoid, low quality)
     bit E..V…. number of bits needed for the block
     rd E..V…. rate distortion optimal, slow
     zero E..V…. 0
     vsad E..V…. sum of absolute vertical differences
     vsse E..V…. sum of squared vertical differences
     nsse E..V…. noise preserving sum of squared differences
     w53 E..V…. 5/3 wavelet, only used in snow
     w97 E..V…. 9/7 wavelet, only used in snow
     dctmax E..V….
     chroma E..V….
  -subcmp E..V…. sub-pel ME compare function (from INT_MIN to INT_MAX) (default 0)
     sad E..V…. sum of absolute differences, fast (default)
     sse E..V…. sum of squared errors
     satd E..V…. sum of absolute Hadamard transformed differences
     dct E..V…. sum of absolute DCT transformed differences
     psnr E..V…. sum of squared quantization errors (avoid, low quality)
     bit E..V…. number of bits needed for the block
     rd E..V…. rate distortion optimal, slow
     zero E..V…. 0
     vsad E..V…. sum of absolute vertical differences
     vsse E..V…. sum of squared vertical differences
     nsse E..V…. noise preserving sum of squared differences
     w53 E..V…. 5/3 wavelet, only used in snow
     w97 E..V…. 9/7 wavelet, only used in snow
     dctmax E..V….
     chroma E..V….
  -mbcmp E..V…. macroblock compare function (from INT_MIN to INT_MAX) (default 0)
     sad E..V…. sum of absolute differences, fast (default)
     sse E..V…. sum of squared errors
     satd E..V…. sum of absolute Hadamard transformed differences
     dct E..V…. sum of absolute DCT transformed differences
     psnr E..V…. sum of squared quantization errors (avoid, low quality)
     bit E..V…. number of bits needed for the block
     rd E..V…. rate distortion optimal, slow
     zero E..V…. 0
     vsad E..V…. sum of absolute vertical differences
     vsse E..V…. sum of squared vertical differences
     nsse E..V…. noise preserving sum of squared differences
     w53 E..V…. 5/3 wavelet, only used in snow
     w97 E..V…. 9/7 wavelet, only used in snow
     dctmax E..V….
     chroma E..V….
  -ildctcmp E..V…. interlaced DCT compare function (from INT_MIN to INT_MAX) (default 8)
     sad E..V…. sum of absolute differences, fast (default)
     sse E..V…. sum of squared errors
     satd E..V…. sum of absolute Hadamard transformed differences
     dct E..V…. sum of absolute DCT transformed differences
     psnr E..V…. sum of squared quantization errors (avoid, low quality)
     bit E..V…. number of bits needed for the block
     rd E..V…. rate distortion optimal, slow
     zero E..V…. 0
     vsad E..V…. sum of absolute vertical differences
     vsse E..V…. sum of squared vertical differences
     nsse E..V…. noise preserving sum of squared differences
     w53 E..V…. 5/3 wavelet, only used in snow
     w97 E..V…. 9/7 wavelet, only used in snow
     dctmax E..V….
     chroma E..V….
  -dia_size E..V…. diamond type & size for motion estimation (from INT_MIN to INT_MAX) (default 0)
  -last_pred E..V…. amount of motion predictors from the previous frame (from INT_MIN to INT_MAX) (default 0)
  -preme E..V…. pre motion estimation (from INT_MIN to INT_MAX) (default 0)
  -precmp E..V…. pre motion estimation compare function (from INT_MIN to INT_MAX) (default 0)
     sad E..V…. sum of absolute differences, fast (default)
     sse E..V…. sum of squared errors
     satd E..V…. sum of absolute Hadamard transformed differences
     dct E..V…. sum of absolute DCT transformed differences
     psnr E..V…. sum of squared quantization errors (avoid, low quality)
     bit E..V…. number of bits needed for the block
     rd E..V…. rate distortion optimal, slow
     zero E..V…. 0
     vsad E..V…. sum of absolute vertical differences
     vsse E..V…. sum of squared vertical differences
     nsse E..V…. noise preserving sum of squared differences
     w53 E..V…. 5/3 wavelet, only used in snow
     w97 E..V…. 9/7 wavelet, only used in snow
     dctmax E..V….
     chroma E..V….
  -pre_dia_size E..V…. diamond type & size for motion estimation pre-pass (from INT_MIN to INT_MAX) (default 0)
  -subq E..V…. sub-pel motion estimation quality (from INT_MIN to INT_MAX) (default 8)
  -me_range E..V…. limit motion vectors range (1023 for DivX player) (from INT_MIN to INT_MAX) (default 0)
  -ibias E..V…. intra quant bias (from INT_MIN to INT_MAX) (default 999999)
  -pbias E..V…. inter quant bias (from INT_MIN to INT_MAX) (default 999999)
  -global_quality E..VA… (from INT_MIN to INT_MAX) (default 0)
  -coder E..V…. (from INT_MIN to INT_MAX) (default 0)
     vlc E..V…. variable length coder / Huffman coder
     ac E..V…. arithmetic coder
     raw E..V…. raw (no encoding)
     rle E..V…. run-length coder
     deflate E..V…. deflate-based coder
  -context E..V…. context model (from INT_MIN to INT_MAX) (default 0)
  -mbd E..V…. macroblock decision algorithm (high quality mode) (from 0 to 2) (default 0)
     simple E..V…. use mbcmp (default)
     bits E..V…. use fewest bits
     rd E..V…. use best rate distortion
  -sc_threshold E..V…. scene change threshold (from INT_MIN to INT_MAX) (default 0)
  -lmin E..V…. minimum Lagrange factor (VBR) (from 0 to INT_MAX) (default 236)
  -lmax E..V…. maximum Lagrange factor (VBR) (from 0 to INT_MAX) (default 3658)
  -nr E..V…. noise reduction (from INT_MIN to INT_MAX) (default 0)
  -rc_init_occupancy E..V…. number of bits which should be loaded into the rc buffer before decoding starts (from INT_MIN to INT_MAX) (default 0)
  -flags2 ED.VA… (default 0)
     fast E..V…. allow non-spec-compliant speedup tricks
     noout E..V…. skip bitstream encoding
     ignorecrop .D.V…. ignore cropping information from sps
     local_header E..V…. place global headers at every keyframe instead of in extradata
     chunks .D.V…. Frame data might be split into multiple chunks
     showall .D.V…. Show all frames before the first keyframe
  -error E..V…. (from INT_MIN to INT_MAX) (default 0)
  -threads ED.VA… (from 0 to INT_MAX) (default 1)
     auto ED.V…. autodetect a suitable number of threads to use
  -me_threshold E..V…. motion estimation threshold (from INT_MIN to INT_MAX) (default 0)
  -mb_threshold E..V…. macroblock threshold (from INT_MIN to INT_MAX) (default 0)
  -dc E..V…. intra_dc_precision (from INT_MIN to INT_MAX) (default 0)
  -nssew E..V…. nsse weight (from INT_MIN to INT_MAX) (default 8)
  -skip_top .D.V…. number of macroblock rows at the top which are skipped (from INT_MIN to INT_MAX) (default 0)
  -skip_bottom .D.V…. number of macroblock rows at the bottom which are skipped (from INT_MIN to INT_MAX) (default 0)
  -profile E..VA… (from INT_MIN to INT_MAX) (default -99)
     unknown E..VA…
     aac_main E…A…
     aac_low E…A…
     aac_ssr E…A…
     aac_ltp E…A…
     aac_he E…A…
     aac_he_v2 E…A…
     aac_ld E…A…
     aac_eld E…A…
     mpeg2_aac_low E…A…
     mpeg2_aac_he E…A…
     dts E…A…
     dts_es E…A…
     dts_96_24 E…A…
     dts_hd_hra E…A…
     dts_hd_ma E…A…
  -level E..VA… (from INT_MIN to INT_MAX) (default -99)
     unknown E..VA…
  -lowres .D.VA… decode at 1= 1/2, 2=1/4, 3=1/8 resolutions (from 0 to INT_MAX) (default 0)
  -skip_threshold E..V…. frame skip threshold (from INT_MIN to INT_MAX) (default 0)
  -skip_factor E..V…. frame skip factor (from INT_MIN to INT_MAX) (default 0)
  -skip_exp E..V…. frame skip exponent (from INT_MIN to INT_MAX) (default 0)
  -skipcmp E..V…. frame skip compare function (from INT_MIN to INT_MAX) (default 13)
     sad E..V…. sum of absolute differences, fast (default)
     sse E..V…. sum of squared errors
     satd E..V…. sum of absolute Hadamard transformed differences
     dct E..V…. sum of absolute DCT transformed differences
     psnr E..V…. sum of squared quantization errors (avoid, low quality)
     bit E..V…. number of bits needed for the block
     rd E..V…. rate distortion optimal, slow
     zero E..V…. 0
     vsad E..V…. sum of absolute vertical differences
     vsse E..V…. sum of squared vertical differences
     nsse E..V…. noise preserving sum of squared differences
     w53 E..V…. 5/3 wavelet, only used in snow
     w97 E..V…. 9/7 wavelet, only used in snow
     dctmax E..V….
     chroma E..V….
  -border_mask E..V…. increase the quantizer for macroblocks close to borders (from -FLT_MAX to FLT_MAX) (default 0)
  -mblmin E..V…. minimum macroblock Lagrange factor (VBR) (from 1 to 32767) (default 236)
  -mblmax E..V…. maximum macroblock Lagrange factor (VBR) (from 1 to 32767) (default 3658)
  -mepc E..V…. motion estimation bitrate penalty compensation (1.0 = 256) (from INT_MIN to INT_MAX) (default 256)
  -skip_loop_filter .D.V…. skip loop filtering process for the selected frames (from INT_MIN to INT_MAX) (default 0)
     none .D.V…. discard no frame
     default .D.V…. discard useless frames
     noref .D.V…. discard all non-reference frames
     bidir .D.V…. discard all bidirectional frames
     nokey .D.V…. discard all frames except keyframes
     all .D.V…. discard all frames
  -skip_idct .D.V…. skip IDCT/dequantization for the selected frames (from INT_MIN to INT_MAX) (default 0)
     none .D.V…. discard no frame
     default .D.V…. discard useless frames
     noref .D.V…. discard all non-reference frames
     bidir .D.V…. discard all bidirectional frames
     nokey .D.V…. discard all frames except keyframes
     all .D.V…. discard all frames
  -skip_frame .D.V…. skip decoding for the selected frames (from INT_MIN to INT_MAX) (default 0)
     none .D.V…. discard no frame
     default .D.V…. discard useless frames
     noref .D.V…. discard all non-reference frames
     bidir .D.V…. discard all bidirectional frames
     nokey .D.V…. discard all frames except keyframes
     all .D.V…. discard all frames
  -bidir_refine E..V…. refine the two motion vectors used in bidirectional macroblocks (from 0 to 4) (default 1)
  -brd_scale E..V…. downscale frames for dynamic B-frame decision (from 0 to 10) (default 0)
  -keyint_min E..V…. minimum interval between IDR-frames (from INT_MIN to INT_MAX) (default 25)
  -refs E..V…. reference frames to consider for motion compensation (from INT_MIN to INT_MAX) (default 1)
  -chromaoffset E..V…. chroma QP offset from luma (from INT_MIN to INT_MAX) (default 0)
  -trellis E..VA… rate-distortion optimal quantization (from INT_MIN to INT_MAX) (default 0)
  -sc_factor E..V…. multiplied by qscale for each frame and added to scene_change_score (from 0 to INT_MAX) (default 6)
  -mv0_threshold E..V…. (from 0 to INT_MAX) (default 256)
  -b_sensitivity E..V…. adjust sensitivity of b_frame_strategy 1 (from 1 to INT_MAX) (default 40)
  -compression_level E..VA… (from INT_MIN to INT_MAX) (default -1)
  -min_prediction_order E…A… (from INT_MIN to INT_MAX) (default -1)
  -max_prediction_order E…A… (from INT_MIN to INT_MAX) (default -1)
  -timecode_frame_start E..V…. GOP timecode frame start number, in non-drop-frame format (from 0 to I64_MAX) (default 0)
  -request_channels .D..A… set desired number of audio channels (from 0 to INT_MAX) (default 0)
  -channel_layout ED..A… (from 0 to I64_MAX) (default 0)
  -request_channel_layout .D..A… (from 0 to I64_MAX) (default 0)
  -rc_max_vbv_use E..V…. (from 0 to FLT_MAX) (default 0)
  -rc_min_vbv_use E..V…. (from 0 to FLT_MAX) (default 3)
  -ticks_per_frame ED.VA… (from 1 to INT_MAX) (default 1)
  -color_primaries ED.V…. (from 1 to 9) (default 2)
  -color_trc ED.V…. (from 1 to 15) (default 2)
  -colorspace ED.V…. (from 1 to 10) (default 2)
  -color_range ED.V…. (from 0 to 2) (default 0)
  -chroma_sample_location ED.V…. (from 0 to 6) (default 0)
  -slices E..V…. number of slices, used in parallelized encoding (from 0 to INT_MAX) (default 0)
  -thread_type ED.VA… select multithreading type (default 3)
     slice ED.V….
     frame ED.V….
  -audio_service_type E…A… audio service type (from 0 to 8) (default 0)
     ma E…A… Main Audio Service
     ef E…A… Effects
     vi E…A… Visually Impaired
     hi E…A… Hearing Impaired
     di E…A… Dialogue
     co E…A… Commentary
     em E…A… Emergency
     vo E…A… Voice Over
     ka E…A… Karaoke
  -request_sample_fmt .D..A… sample format audio decoders should prefer (default none)
  -sub_charenc .D…S.. set input text subtitles character encoding
  -sub_charenc_mode .D…S.. set input text subtitles character encoding mode (default 0)
     do_nothing .D…S..
     auto .D…S..
     pre_decoder .D…S..
  -refcounted_frames .D.VA… (from 0 to 1) (default 0)
  -skip_alpha .D.V…. Skip processing alpha (from 0 to 1) (default 0)
  -field_order ED.V…. Field order (from 0 to 5) (default 0)
     progressive ED.V….
     tt ED.V….
     bb ED.V….
     tb ED.V….
     bt ED.V….

cinepak AVOptions:
  -max_extra_cb_iterations E..V…. Max extra codebook recalculation passes, more is better and slower (from 0 to INT_MAX) (default 2)
  -skip_empty_cb E..V…. Avoid wasting bytes, ignore vintage MacOS decoder (from 0 to 1) (default 0)
  -max_strips E..V…. Limit strips/frame, vintage compatible is 1..3, otherwise the more the better (from 1 to 32) (default 3)
  -min_strips E..V…. Enforce min strips/frame, more is worse and faster, must be <= max_strips (from 1 to 32) (default 1)
  -strip_number_adaptivity E..V…. How fast the strip number adapts, more is slightly better, much slower (from 0 to 31) (default 0)

cljr encoder AVOptions:
  -dither_type E..V…. Dither type (from 0 to 2) (default 1)

dnxhd AVOptions:
  -nitris_compat E..V…. encode with Avid Nitris compatibility (from 0 to 1) (default 0)

EXR AVOptions:
  -layer .D.V…. Set the decoding layer (default “”)

ffv1 encoder AVOptions:
  -slicecrc E..V…. Protect slices with CRCs (from -1 to 1) (default -1)

flv encoder AVOptions:
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

frwu Decoder AVOptions:
  -change_field_order .D.V…. Change field order (from 0 to 1) (default 0)

GIF encoder AVOptions:
  -gifflags E..V…. set GIF flags (default 3)
     offsetting E..V…. enable picture offsetting
     transdiff E..V…. enable transparency detection between frames

gif decoder AVOptions:
  -trans_color .D.V…. color value (ARGB) that is used instead of transparent color (from 0 to UINT32_MAX) (default 1.67772e+007)

h261 encoder AVOptions:
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

H.263 encoder AVOptions:
  -obmc E..V…. use overlapped block motion compensation. (from 0 to 1) (default 0)
  -structured_slices E..V…. Write slice start position at every GOB header instead of just GOB number. (from 0 to 1) (default 0)
  -mb_info E..V…. emit macroblock info for RFC 2190 packetization, the parameter value is the maximum payload size (from 0 to INT_MAX) (default 0)
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

H.263p encoder AVOptions:
  -umv E..V…. Use unlimited motion vectors. (from 0 to 1) (default 0)
  -aiv E..V…. Use alternative inter VLC. (from 0 to 1) (default 0)
  -obmc E..V…. use overlapped block motion compensation. (from 0 to 1) (default 0)
  -structured_slices E..V…. Write slice start position at every GOB header instead of just GOB number. (from 0 to 1) (default 0)
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

H264 Decoder AVOptions:

HEVC decoder AVOptions:
  -apply_defdispwin .D.V…. Apply default display window from VUI (from 0 to 1) (default 0)
  -strict-displaywin .D.V…. stricly apply default display window size (from 0 to 1) (default 0)

jpeg2000 AVOptions:
  -lowres .D.V…. Lower the decoding resolution by a power of two (from 0 to 32) (default 0)

MJPEG decoder AVOptions:
  -extern_huff .D.V…. Use external huffman table. (from 0 to 1) (default 0)

mpeg1video encoder AVOptions:
  -gop_timecode E..V…. MPEG GOP Timecode in hh:mm:ss[:;.]ff format
  -intra_vlc E..V…. Use MPEG-2 intra VLC table. (from 0 to 1) (default 0)
  -drop_frame_timecode E..V…. Timecode is in drop frame format. (from 0 to 1) (default 0)
  -scan_offset E..V…. Reserve space for SVCD scan offset user data. (from 0 to 1) (default 0)
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

mpeg2video encoder AVOptions:
  -gop_timecode E..V…. MPEG GOP Timecode in hh:mm:ss[:;.]ff format
  -intra_vlc E..V…. Use MPEG-2 intra VLC table. (from 0 to 1) (default 0)
  -drop_frame_timecode E..V…. Timecode is in drop frame format. (from 0 to 1) (default 0)
  -scan_offset E..V…. Reserve space for SVCD scan offset user data. (from 0 to 1) (default 0)
  -non_linear_quant E..V…. Use nonlinear quantizer. (from 0 to 1) (default 0)
  -alternate_scan E..V…. Enable alternate scantable. (from 0 to 1) (default 0)
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

MPEG4 encoder AVOptions:
  -data_partitioning E..V…. Use data partitioning. (from 0 to 1) (default 0)
  -alternate_scan E..V…. Enable alternate scantable. (from 0 to 1) (default 0)
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

MPEG4 Video Decoder AVOptions:

msmpeg4v2 encoder AVOptions:
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

msmpeg4v3 encoder AVOptions:
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

PNG encoder AVOptions:
  -dpi E..V…. Set image resolution (in dots per inch) (from 0 to 65536) (default 0)
  -dpm E..V…. Set image resolution (in dots per meter) (from 0 to 65536) (default 0)

ProRes encoder AVOptions:
  -mbs_per_slice E..V…. macroblocks per slice (from 1 to 8) (default 8)
  -profile E..V…. (from 0 to 4) (default 2)
     proxy E..V….
     lt E..V….
     standard E..V….
     hq E..V….
     4444 E..V….
  -vendor E..V…. vendor ID (default “Lavc”)
  -bits_per_mb E..V…. desired bits per macroblock (from 0 to 8192) (default 0)
  -quant_mat E..V…. quantiser matrix (from -1 to 4) (default -1)
     auto E..V….
     proxy E..V….
     lt E..V….
     standard E..V….
     hq E..V….
     default E..V….
  -alpha_bits E..V…. bits for alpha plane (from 0 to 16) (default 16)

rawdec AVOptions:
  -top .D.V…. top field first (from -1 to 1) (default -1)

RoQ AVOptions:
  -quake3_compat E..V…. Whether to respect known limitations in Quake 3 decoder (from 0 to 1) (default 1)

rv10 encoder AVOptions:
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

rv20 encoder AVOptions:
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

snow encoder AVOptions:
  -memc_only E..V…. Only do ME/MC (I frames -> ref, P frame -> ME+MC). (from 0 to 1) (default 0)
  -no_bitstream E..V…. Skip final bitstream writeout. (from 0 to 1) (default 0)

TIFF encoder AVOptions:
  -dpi E..V…. set the image resolution (in dpi) (from 1 to 65536) (default 72)
  -compression_algo E..V…. (from 1 to 32946) (default 32773)
     packbits E..V….
     raw E..V….
     lzw E..V….
     deflate E..V….

V210 Decoder AVOptions:
  -custom_stride .D.V…. Custom V210 stride (from INT_MIN to INT_MAX) (default 0)

wmv1 encoder AVOptions:
  -mpv_flags E..V…. Flags common for all mpegvideo-based encoders. (default 0)
     skip_rd E..V…. RD optimal MB level residual skipping
     strict_gop E..V…. Strictly enforce gop size
     qp_rd E..V…. Use rate distortion optimization for qp selection
     cbp_rd E..V…. use rate distortion optimization for CBP
  -luma_elim_threshold E..V…. single coefficient elimination threshold for luminance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -chroma_elim_threshold E..V…. single coefficient elimination threshold for chrominance (negative values also consider dc coefficient) (from INT_MIN to INT_MAX) (default 0)
  -quantizer_noise_shaping E..V…. (from 0 to INT_MAX) (default 0)
  -error_rate E..V…. Simulate errors in the bitstream to test error concealment. (from 0 to INT_MAX) (default 0)

AAC encoder AVOptions:
  -stereo_mode E…A… Stereo coding method (from -1 to 1) (default 0)
     auto E…A… Selected by the Encoder
     ms_off E…A… Disable Mid/Side coding
     ms_force E…A… Force Mid/Side for the whole frame if possible
  -aac_coder E…A… (from 0 to 3) (default 2)
     faac E…A… FAAC-inspired method
     anmr E…A… ANMR method
     twoloop E…A… Two loop searching method
     fast E…A… Constant quantizer

AAC decoder AVOptions:
  -dual_mono_mode .D..A… Select the channel to decode for dual mono (from -1 to 2) (default -1)
     auto .D..A… autoselection
     main .D..A… Select Main/Left channel
     sub .D..A… Select Sub/Right channel
     both .D..A… Select both channels

AC-3 Encoder AVOptions:
  -per_frame_metadata E…A… Allow Changing Metadata Per-Frame (from 0 to 1) (default 0)
  -center_mixlev E…A… Center Mix Level (from 0 to 1) (default 0.594604)
  -surround_mixlev E…A… Surround Mix Level (from 0 to 1) (default 0.5)
  -mixing_level E…A… Mixing Level (from -1 to 111) (default -1)
  -room_type E…A… Room Type (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     large E…A… Large Room
     small E…A… Small Room
  -copyright E…A… Copyright Bit (from -1 to 1) (default -1)
  -dialnorm E…A… Dialogue Level (dB) (from -31 to -1) (default -31)
  -dsur_mode E…A… Dolby Surround Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Surround Encoded
     off E…A… Not Dolby Surround Encoded
  -original E…A… Original Bit Stream (from -1 to 1) (default -1)
  -dmix_mode E…A… Preferred Stereo Downmix Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     ltrt E…A… Lt/Rt Downmix Preferred
     loro E…A… Lo/Ro Downmix Preferred
  -ltrt_cmixlev E…A… Lt/Rt Center Mix Level (from -1 to 2) (default -1)
  -ltrt_surmixlev E…A… Lt/Rt Surround Mix Level (from -1 to 2) (default -1)
  -loro_cmixlev E…A… Lo/Ro Center Mix Level (from -1 to 2) (default -1)
  -loro_surmixlev E…A… Lo/Ro Surround Mix Level (from -1 to 2) (default -1)
  -dsurex_mode E…A… Dolby Surround EX Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Surround EX Encoded
     off E…A… Not Dolby Surround EX Encoded
  -dheadphone_mode E…A… Dolby Headphone Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Headphone Encoded
     off E…A… Not Dolby Headphone Encoded
  -ad_conv_type E…A… A/D Converter Type (from -1 to 1) (default -1)
     standard E…A… Standard (default)
     hdcd E…A… HDCD
  -stereo_rematrixing E…A… Stereo Rematrixing (from 0 to 1) (default 1)
  -channel_coupling E…A… Channel Coupling (from -1 to 1) (default -1)
     auto E…A… Selected by the Encoder
  -cpl_start_band E…A… Coupling Start Band (from -1 to 15) (default -1)
     auto E…A… Selected by the Encoder

AC3 decoder AVOptions:
  -drc_scale .D..A… percentage of dynamic range compression to apply (from 0 to 6) (default 1)

Fixed-Point AC-3 Encoder AVOptions:
  -per_frame_metadata E…A… Allow Changing Metadata Per-Frame (from 0 to 1) (default 0)
  -center_mixlev E…A… Center Mix Level (from 0 to 1) (default 0.594604)
  -surround_mixlev E…A… Surround Mix Level (from 0 to 1) (default 0.5)
  -mixing_level E…A… Mixing Level (from -1 to 111) (default -1)
  -room_type E…A… Room Type (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     large E…A… Large Room
     small E…A… Small Room
  -copyright E…A… Copyright Bit (from -1 to 1) (default -1)
  -dialnorm E…A… Dialogue Level (dB) (from -31 to -1) (default -31)
  -dsur_mode E…A… Dolby Surround Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Surround Encoded
     off E…A… Not Dolby Surround Encoded
  -original E…A… Original Bit Stream (from -1 to 1) (default -1)
  -dmix_mode E…A… Preferred Stereo Downmix Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     ltrt E…A… Lt/Rt Downmix Preferred
     loro E…A… Lo/Ro Downmix Preferred
  -ltrt_cmixlev E…A… Lt/Rt Center Mix Level (from -1 to 2) (default -1)
  -ltrt_surmixlev E…A… Lt/Rt Surround Mix Level (from -1 to 2) (default -1)
  -loro_cmixlev E…A… Lo/Ro Center Mix Level (from -1 to 2) (default -1)
  -loro_surmixlev E…A… Lo/Ro Surround Mix Level (from -1 to 2) (default -1)
  -dsurex_mode E…A… Dolby Surround EX Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Surround EX Encoded
     off E…A… Not Dolby Surround EX Encoded
  -dheadphone_mode E…A… Dolby Headphone Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Headphone Encoded
     off E…A… Not Dolby Headphone Encoded
  -ad_conv_type E…A… A/D Converter Type (from -1 to 1) (default -1)
     standard E…A… Standard (default)
     hdcd E…A… HDCD
  -stereo_rematrixing E…A… Stereo Rematrixing (from 0 to 1) (default 1)
  -channel_coupling E…A… Channel Coupling (from -1 to 1) (default -1)
     auto E…A… Selected by the Encoder
  -cpl_start_band E…A… Coupling Start Band (from -1 to 15) (default -1)
     auto E…A… Selected by the Encoder

Fixed-Point AC-3 Decoder AVOptions:

APE decoder AVOptions:
  -max_samples .D..A… maximum number of samples decoded per call (from 1 to INT_MAX) (default 4608)
     all .D..A… no maximum. decode all samples for each packet at once

DCA decoder AVOptions:
  -disable_xch .D..A… disable decoding of the XCh extension (from 0 to 1) (default 0)

E-AC-3 Encoder AVOptions:
  -per_frame_metadata E…A… Allow Changing Metadata Per-Frame (from 0 to 1) (default 0)
  -mixing_level E…A… Mixing Level (from -1 to 111) (default -1)
  -room_type E…A… Room Type (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     large E…A… Large Room
     small E…A… Small Room
  -copyright E…A… Copyright Bit (from -1 to 1) (default -1)
  -dialnorm E…A… Dialogue Level (dB) (from -31 to -1) (default -31)
  -dsur_mode E…A… Dolby Surround Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Surround Encoded
     off E…A… Not Dolby Surround Encoded
  -original E…A… Original Bit Stream (from -1 to 1) (default -1)
  -dmix_mode E…A… Preferred Stereo Downmix Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     ltrt E…A… Lt/Rt Downmix Preferred
     loro E…A… Lo/Ro Downmix Preferred
  -ltrt_cmixlev E…A… Lt/Rt Center Mix Level (from -1 to 2) (default -1)
  -ltrt_surmixlev E…A… Lt/Rt Surround Mix Level (from -1 to 2) (default -1)
  -loro_cmixlev E…A… Lo/Ro Center Mix Level (from -1 to 2) (default -1)
  -loro_surmixlev E…A… Lo/Ro Surround Mix Level (from -1 to 2) (default -1)
  -dsurex_mode E…A… Dolby Surround EX Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Surround EX Encoded
     off E…A… Not Dolby Surround EX Encoded
  -dheadphone_mode E…A… Dolby Headphone Mode (from -1 to 2) (default -1)
     notindicated E…A… Not Indicated (default)
     on E…A… Dolby Headphone Encoded
     off E…A… Not Dolby Headphone Encoded
  -ad_conv_type E…A… A/D Converter Type (from -1 to 1) (default -1)
     standard E…A… Standard (default)
     hdcd E…A… HDCD
  -stereo_rematrixing E…A… Stereo Rematrixing (from 0 to 1) (default 1)
  -channel_coupling E…A… Channel Coupling (from -1 to 1) (default -1)
     auto E…A… Selected by the Encoder
  -cpl_start_band E…A… Coupling Start Band (from -1 to 15) (default -1)
     auto E…A… Selected by the Encoder

E-AC3 decoder AVOptions:
  -drc_scale .D..A… percentage of dynamic range compression to apply (from 0 to 6) (default 1)

FLAC encoder AVOptions:
  -lpc_coeff_precision E…A… LPC coefficient precision (from 0 to 15) (default 15)
  -lpc_type E…A… LPC algorithm (from -1 to 3) (default -1)
     none E…A…
     fixed E…A…
     levinson E…A…
     cholesky E…A…
  -lpc_passes E…A… Number of passes to use for Cholesky factorization during LPC analysis (from 1 to INT_MAX) (default 2)
  -min_partition_order E…A… (from -1 to 8) (default -1)
  -max_partition_order E…A… (from -1 to 8) (default -1)
  -prediction_order_method E…A… Search method for selecting prediction order (from -1 to 5) (default -1)
     estimation E…A…
     2level E…A…
     4level E…A…
     8level E…A…
     search E…A…
     log E…A…
  -ch_mode E…A… Stereo decorrelation mode (from -1 to 3) (default -1)
     auto E…A…
     indep E…A…
     left_side E…A…
     right_side E…A…
     mid_side E…A…

G.723.1 decoder AVOptions:
  -postfilter .D..A… postfilter on/off (from 0 to 1) (default 1)

TTA Decoder AVOptions:
  -password .D..A… Set decoding password

WavPack encoder AVOptions:
  -joint_stereo E…A… (from -1 to 1) (default 0)
     on E…A… mid/side
     off E…A… left/right
     auto E…A…
  -optimize_mono E…A… (from 0 to 1) (default 0)
     on E…A…
     off E…A…

g722 decoder AVOptions:
  -bits_per_codeword .D..A… Bits per G722 codeword (from 6 to 8) (default 8)

g726 AVOptions:
  -code_size E…A… Bits per code (from 2 to 5) (default 4)

dvdsubdec AVOptions:
  -palette .D…S.. set the global palette

PGS subtitle decoder AVOptions:
  -forced_subs_only .D…S.. Only show forced subtitles (from 0 to 1) (default 0)

pjs decoder AVOptions:
  -keep_ass_markup .D…S.. Set if ASS tags must be escaped (from 0 to 1) (default 0)

subviewer1 decoder AVOptions:
  -keep_ass_markup .D…S.. Set if ASS tags must be escaped (from 0 to 1) (default 0)

text decoder AVOptions:
  -keep_ass_markup .D…S.. Set if ASS tags must be escaped (from 0 to 1) (default 0)

vplayer decoder AVOptions:
  -keep_ass_markup .D…S.. Set if ASS tags must be escaped (from 0 to 1) (default 0)

libilbc AVOptions:
  -mode E…A… iLBC mode (20 or 30 ms frames) (from 20 to 30) (default 20)

libilbc AVOptions:
  -enhance .D..A… Enhance the decoded audio (adds delay) (from 0 to 1) (default 0)

libmp3lame encoder AVOptions:
  -reservoir E…A… use bit reservoir (from 0 to 1) (default 1)
  -joint_stereo E…A… use joint stereo (from 0 to 1) (default 1)
  -abr E…A… use ABR (from 0 to 1) (default 0)

libopencore_amrnb AVOptions:
  -dtx E…A… Allow DTX (generate comfort noise) (from 0 to 1) (default 0)

libopenjpeg AVOptions:
  -format E..V…. Codec Format (from 0 to 2) (default 2)
     j2k E..V….
     jp2 E..V….
  -profile E..V…. (from 0 to 4) (default 0)
     jpeg2000 E..V….
     cinema2k E..V….
     cinema4k E..V….
  -cinema_mode E..V…. Digital Cinema (from 0 to 3) (default 0)
     off E..V….
     2k_24 E..V….
     2k_48 E..V….
     4k_24 E..V….
  -prog_order E..V…. Progression Order (from 0 to 4) (default 0)
     lrcp E..V….
     rlcp E..V….
     rpcl E..V….
     pcrl E..V….
     cprl E..V….
  -numresolution E..V…. (from 1 to INT_MAX) (default 6)
  -numlayers E..V…. (from 1 to 10) (default 1)
  -disto_alloc E..V…. (from 0 to 1) (default 1)
  -fixed_alloc E..V…. (from 0 to 1) (default 0)
  -fixed_quality E..V…. (from 0 to 1) (default 0)

libopenjpeg AVOptions:
  -lowqual .D.V…. Limit the number of layers used for decoding (from 0 to INT_MAX) (default 0)

libopus AVOptions:
  -application E…A… Intended application type (from 2048 to 2051) (default 2049)
     voip E…A… Favor improved speech intelligibility
     audio E…A… Favor faithfulness to the input
     lowdelay E…A… Restrict to only the lowest delay modes
  -frame_duration E…A… Duration of a frame in milliseconds (from 2.5 to 60) (default 20)
  -packet_loss E…A… Expected packet loss percentage (from 0 to 100) (default 0)
  -vbr E…A… Variable bit rate mode (from 0 to 2) (default 1)
     off E…A… Use constant bit rate
     on E…A… Use variable bit rate
     constrained E…A… Use constrained VBR

libspeex AVOptions:
  -abr E…A… Use average bit rate (from 0 to 1) (default 0)
  -cbr_quality E…A… Set quality value (0 to 10) for CBR (from 0 to 10) (default 8)
  -frames_per_packet E…A… Number of frames to encode in each packet (from 1 to 8) (default 1)
  -vad E…A… Voice Activity Detection (from 0 to 1) (default 0)
  -dtx E…A… Discontinuous Transmission (from 0 to 1) (default 0)

libtwolame encoder AVOptions:
  -mode E…A… Mpeg Mode (from -1 to 3) (default -1)
     auto E…A…
     stereo E…A…
     joint_stereo E…A…
     dual_channel E…A…
     mono E…A…
  -psymodel E…A… Psychoacoustic Model (from -1 to 4) (default 3)
  -energy_levels E…A… enable energy levels (from 0 to 1) (default 0)
  -error_protection E…A… enable CRC error protection (from 0 to 1) (default 0)
  -copyright E…A… set MPEG Audio Copyright flag (from 0 to 1) (default 0)
  -original E…A… set MPEG Audio Original flag (from 0 to 1) (default 0)
  -verbosity E…A… set library optput level (0-10) (from 0 to 10) (default 0)

libvo_amrwbenc AVOptions:
  -dtx E…A… Allow DTX (generate comfort noise) (from 0 to 1) (default 0)

libvorbis AVOptions:
  -iblock E…A… Sets the impulse block bias (from -15 to 0) (default 0)

libvpx-vp8 encoder AVOptions:
  -cpu-used E..V…. Quality/Speed ratio modifier (from INT_MIN to INT_MAX) (default INT_MIN)
  -auto-alt-ref E..V…. Enable use of alternate reference frames (2-pass only) (from -1 to 1) (default -1)
  -lag-in-frames E..V…. Number of frames to look ahead for alternate reference frame selection (from -1 to INT_MAX) (default -1)
  -arnr-maxframes E..V…. altref noise reduction max frame count (from -1 to INT_MAX) (default -1)
  -arnr-strength E..V…. altref noise reduction filter strength (from -1 to INT_MAX) (default -1)
  -arnr-type E..V…. altref noise reduction filter type (from -1 to INT_MAX) (default -1)
     backward E..V….
     forward E..V….
     centered E..V….
  -deadline E..V…. Time to spend encoding, in microseconds. (from INT_MIN to INT_MAX) (default 1e+006)
     best E..V….
     good E..V….
     realtime E..V….
  -error-resilient E..V…. Error resilience configuration (default 0)
     default E..V…. Improve resiliency against losses of whole frames
     partitions E..V…. The frame partitions are independently decodable by the bool decoder, meaning that partitions can be decoded even though earlier partitions have been lost. Note that intra predicition is still done over the partition boundary.
  -max-intra-rate E..V…. Maximum I-frame bitrate (pct) 0=unlimited (from -1 to INT_MAX) (default -1)
  -crf E..V…. Select the quality for constant quality mode (from 0 to 63) (default 0)
  -speed E..V…. (from -16 to 16) (default 1)
  -quality E..V…. (from INT_MIN to INT_MAX) (default 1e+006)
     best E..V….
     good E..V….
     realtime E..V….
  -vp8flags E..V…. (default 0)
     error_resilient E..V…. enable error resilience
     altref E..V…. enable use of alternate reference frames (VP8/2-pass only)
  -arnr_max_frames E..V…. altref noise reduction max frame count (from 0 to 15) (default 0)
  -arnr_strength E..V…. altref noise reduction filter strength (from 0 to 6) (default 3)
  -arnr_type E..V…. altref noise reduction filter type (from 1 to 3) (default 3)
  -rc_lookahead E..V…. Number of frames to look ahead for alternate reference frame selection (from 0 to 25) (default 25)

libvpx-vp9 encoder AVOptions:
  -cpu-used E..V…. Quality/Speed ratio modifier (from INT_MIN to INT_MAX) (default INT_MIN)
  -auto-alt-ref E..V…. Enable use of alternate reference frames (2-pass only) (from -1 to 1) (default -1)
  -lag-in-frames E..V…. Number of frames to look ahead for alternate reference frame selection (from -1 to INT_MAX) (default -1)
  -arnr-maxframes E..V…. altref noise reduction max frame count (from -1 to INT_MAX) (default -1)
  -arnr-strength E..V…. altref noise reduction filter strength (from -1 to INT_MAX) (default -1)
  -arnr-type E..V…. altref noise reduction filter type (from -1 to INT_MAX) (default -1)
     backward E..V….
     forward E..V….
     centered E..V….
  -deadline E..V…. Time to spend encoding, in microseconds. (from INT_MIN to INT_MAX) (default 1e+006)
     best E..V….
     good E..V….
     realtime E..V….
  -error-resilient E..V…. Error resilience configuration (default 0)
     default E..V…. Improve resiliency against losses of whole frames
     partitions E..V…. The frame partitions are independently decodable by the bool decoder, meaning that partitions can be decoded even though earlier partitions have been lost. Note that intra predicition is still done over the partition boundary.
  -max-intra-rate E..V…. Maximum I-frame bitrate (pct) 0=unlimited (from -1 to INT_MAX) (default -1)
  -crf E..V…. Select the quality for constant quality mode (from 0 to 63) (default 0)
  -lossless E..V…. Lossless mode (from -1 to 1) (default -1)
  -tile-columns E..V…. Number of tile columns to use, log2 (from -1 to 6) (default -1)
  -tile-rows E..V…. Number of tile rows to use, log2 (from -1 to 2) (default -1)
  -frame-parallel E..V…. Enable frame parallel decodability features (from -1 to 1) (default -1)
  -speed E..V…. (from -16 to 16) (default 1)
  -quality E..V…. (from INT_MIN to INT_MAX) (default 1e+006)
     best E..V….
     good E..V….
     realtime E..V….
  -vp8flags E..V…. (default 0)
     error_resilient E..V…. enable error resilience
     altref E..V…. enable use of alternate reference frames (VP8/2-pass only)
  -arnr_max_frames E..V…. altref noise reduction max frame count (from 0 to 15) (default 0)
  -arnr_strength E..V…. altref noise reduction filter strength (from 0 to 6) (default 3)
  -arnr_type E..V…. altref noise reduction filter type (from 1 to 3) (default 3)
  -rc_lookahead E..V…. Number of frames to look ahead for alternate reference frame selection (from 0 to 25) (default 25)

libx264 AVOptions:
  -preset E..V…. Set the encoding preset (cf. x264 —fullhelp) (default “medium”)
  -tune E..V…. Tune the encoding params (cf. x264 —fullhelp)
  -profile E..V…. Set profile restrictions (cf. x264 —fullhelp) 
  -fastfirstpass E..V…. Use fast settings when encoding first pass (from 0 to 1) (default 1)
  -level E..V…. Specify level (as defined by Annex A)
  -passlogfile E..V…. Filename for 2 pass stats
  -wpredp E..V…. Weighted prediction for P-frames
  -x264opts E..V…. x264 options
  -crf E..V…. Select the quality for constant quality mode (from -1 to FLT_MAX) (default -1)
  -crf_max E..V…. In CRF mode, prevents VBV from lowering quality beyond this point. (from -1 to FLT_MAX) (default -1)
  -qp E..V…. Constant quantization parameter rate control method (from -1 to INT_MAX) (default -1)
  -aq-mode E..V…. AQ method (from -1 to INT_MAX) (default -1)
     none E..V….
     variance E..V…. Variance AQ (complexity mask)
     autovariance E..V…. Auto-variance AQ (experimental)
  -aq-strength E..V…. AQ strength. Reduces blocking and blurring in flat and textured areas. (from -1 to FLT_MAX) (default -1)
  -psy E..V…. Use psychovisual optimizations. (from -1 to 1) (default -1)
  -psy-rd E..V…. Strength of psychovisual optimization, in : format.
  -rc-lookahead E..V…. Number of frames to look ahead for frametype and ratecontrol (from -1 to INT_MAX) (default -1)
  -weightb E..V…. Weighted prediction for B-frames. (from -1 to 1) (default -1)
  -weightp E..V…. Weighted prediction analysis method. (from -1 to INT_MAX) (default -1)
     none E..V….
     simple E..V….
     smart E..V….
  -ssim E..V…. Calculate and print SSIM stats. (from -1 to 1) (default -1)
  -intra-refresh E..V…. Use Periodic Intra Refresh instead of IDR frames. (from -1 to 1) (default -1)
  -bluray-compat E..V…. Bluray compatibility workarounds. (from -1 to 1) (default -1)
  -b-bias E..V…. Influences how often B-frames are used (from INT_MIN to INT_MAX) (default INT_MIN)
  -b-pyramid E..V…. Keep some B-frames as references. (from -1 to INT_MAX) (default -1)
     none E..V….
     strict E..V…. Strictly hierarchical pyramid
     normal E..V…. Non-strict (not Blu-ray compatible)
  -mixed-refs E..V…. One reference per partition, as opposed to one reference per macroblock (from -1 to 1) (default -1)
  -8×8dct E..V…. High profile 8×8 transform. (from -1 to 1) (default -1)
  -fast-pskip E..V…. (from -1 to 1) (default -1)
  -aud E..V…. Use access unit delimiters. (from -1 to 1) (default -1)
  -mbtree E..V…. Use macroblock tree ratecontrol. (from -1 to 1) (default -1)
  -deblock E..V…. Loop filter parameters, in form.
  -cplxblur E..V…. Reduce fluctuations in QP (before curve compression) (from -1 to FLT_MAX) (default -1)
  -partitions E..V…. A comma-separated list of partitions to consider. Possible values: p8×8, p4×4, b8×8, i8×8, i4×4, none, all
  -direct-pred E..V…. Direct MV prediction mode (from -1 to INT_MAX) (default -1)
     none E..V….
     spatial E..V….
     temporal E..V….
     auto E..V….
  -slice-max-size E..V…. Limit the size of each slice in bytes (from -1 to INT_MAX) (default -1)
  -stats E..V…. Filename for 2 pass stats
  -nal-hrd E..V…. Signal HRD information (requires vbv-bufsize; cbr not allowed in .mp4) (from -1 to INT_MAX) (default -1)
     none E..V….
     vbr E..V….
     cbr E..V….
  -x264-params E..V…. Override the x264 configuration using a :-separated list of key=value parameters

libx264rgb AVOptions:
  -preset E..V…. Set the encoding preset (cf. x264 —fullhelp) (default “medium”)
  -tune E..V…. Tune the encoding params (cf. x264 —fullhelp)
  -profile E..V…. Set profile restrictions (cf. x264 —fullhelp) 
  -fastfirstpass E..V…. Use fast settings when encoding first pass (from 0 to 1) (default 1)
  -level E..V…. Specify level (as defined by Annex A)
  -passlogfile E..V…. Filename for 2 pass stats
  -wpredp E..V…. Weighted prediction for P-frames
  -x264opts E..V…. x264 options
  -crf E..V…. Select the quality for constant quality mode (from -1 to FLT_MAX) (default -1)
  -crf_max E..V…. In CRF mode, prevents VBV from lowering quality beyond this point. (from -1 to FLT_MAX) (default -1)
  -qp E..V…. Constant quantization parameter rate control method (from -1 to INT_MAX) (default -1)
  -aq-mode E..V…. AQ method (from -1 to INT_MAX) (default -1)
     none E..V….
     variance E..V…. Variance AQ (complexity mask)
     autovariance E..V…. Auto-variance AQ (experimental)
  -aq-strength E..V…. AQ strength. Reduces blocking and blurring in flat and textured areas. (from -1 to FLT_MAX) (default -1)
  -psy E..V…. Use psychovisual optimizations. (from -1 to 1) (default -1)
  -psy-rd E..V…. Strength of psychovisual optimization, in : format.
  -rc-lookahead E..V…. Number of frames to look ahead for frametype and ratecontrol (from -1 to INT_MAX) (default -1)
  -weightb E..V…. Weighted prediction for B-frames. (from -1 to 1) (default -1)
  -weightp E..V…. Weighted prediction analysis method. (from -1 to INT_MAX) (default -1)
     none E..V….
     simple E..V….
     smart E..V….
  -ssim E..V…. Calculate and print SSIM stats. (from -1 to 1) (default -1)
  -intra-refresh E..V…. Use Periodic Intra Refresh instead of IDR frames. (from -1 to 1) (default -1)
  -bluray-compat E..V…. Bluray compatibility workarounds. (from -1 to 1) (default -1)
  -b-bias E..V…. Influences how often B-frames are used (from INT_MIN to INT_MAX) (default INT_MIN)
  -b-pyramid E..V…. Keep some B-frames as references. (from -1 to INT_MAX) (default -1)
     none E..V….
     strict E..V…. Strictly hierarchical pyramid
     normal E..V…. Non-strict (not Blu-ray compatible)
  -mixed-refs E..V…. One reference per partition, as opposed to one reference per macroblock (from -1 to 1) (default -1)
  -8×8dct E..V…. High profile 8×8 transform. (from -1 to 1) (default -1)
  -fast-pskip E..V…. (from -1 to 1) (default -1)
  -aud E..V…. Use access unit delimiters. (from -1 to 1) (default -1)
  -mbtree E..V…. Use macroblock tree ratecontrol. (from -1 to 1) (default -1)
  -deblock E..V…. Loop filter parameters, in form.
  -cplxblur E..V…. Reduce fluctuations in QP (before curve compression) (from -1 to FLT_MAX) (default -1)
  -partitions E..V…. A comma-separated list of partitions to consider. Possible values: p8×8, p4×4, b8×8, i8×8, i4×4, none, all
  -direct-pred E..V…. Direct MV prediction mode (from -1 to INT_MAX) (default -1)
     none E..V….
     spatial E..V….
     temporal E..V….
     auto E..V….
  -slice-max-size E..V…. Limit the size of each slice in bytes (from -1 to INT_MAX) (default -1)
  -stats E..V…. Filename for 2 pass stats
  -nal-hrd E..V…. Signal HRD information (requires vbv-bufsize; cbr not allowed in .mp4) (from -1 to INT_MAX) (default -1)
     none E..V….
     vbr E..V….
     cbr E..V….
  -x264-params E..V…. Override the x264 configuration using a :-separated list of key=value parameters

libx265 AVOptions:
  -preset E..V…. set the x265 preset
  -tune E..V…. set the x265 tune parameter
  -x265-params E..V…. set the x265 configuration using a :-separated list of key=value parameters

libxavs AVOptions:
  -crf E..V…. Select the quality for constant quality mode (from -1 to FLT_MAX) (default -1)
  -qp E..V…. Constant quantization parameter rate control method (from -1 to INT_MAX) (default -1)
  -b-bias E..V…. Influences how often B-frames are used (from INT_MIN to INT_MAX) (default INT_MIN)
  -cplxblur E..V…. Reduce fluctuations in QP (before curve compression) (from -1 to FLT_MAX) (default -1)
  -direct-pred E..V…. Direct MV prediction mode (from -1 to INT_MAX) (default -1)
     none E..V….
     spatial E..V….
     temporal E..V….
     auto E..V….
  -aud E..V…. Use access unit delimiters. (from -1 to 1) (default -1)
  -mbtree E..V…. Use macroblock tree ratecontrol. (from -1 to 1) (default -1)
  -mixed-refs E..V…. One reference per partition, as opposed to one reference per macroblock (from -1 to 1) (default -1)
  -fast-pskip E..V…. (from -1 to 1) (default -1)

libxvid AVOptions:
  -lumi_aq E..V…. Luminance masking AQ (from 0 to 1) (default 0)
  -variance_aq E..V…. Variance AQ (from 0 to 1) (default 0)
  -ssim E..V…. Show SSIM information to stdout (from 0 to 2) (default 0)
     off E..V….
     avg E..V….
     frame E..V….
  -ssim_acc E..V…. SSIM accuracy (from 0 to 4) (default 2)

AVFormatContext AVOptions:
  -avioflags ED…… (default 0)
     direct ED…… reduce buffering
  -probesize .D…… set probing size (from 32 to INT_MAX) (default 5e+006)
  -packetsize E……. set packet size (from 0 to INT_MAX) (default 0)
  -fflags ED…… (default 200)
     flush_packets .D…… reduce the latency by flushing out packets immediately
     ignidx .D…… ignore index
     genpts .D…… generate pts
     nofillin .D…… do not fill in missing values that can be exactly calculated
     noparse .D…… disable AVParsers, this needs nofillin too
     igndts .D…… ignore dts
     discardcorrupt .D…… discard corrupted frames
     sortdts .D…… try to interleave outputted packets by dts
     keepside .D…… don’t merge side data
     latm E……. enable RTP MP4A-LATM payload
     nobuffer .D…… reduce the latency introduced by optional buffering
  -seek2any .D…… allow seeking to non-keyframes on demuxer level when supported (from 0 to 1) (default 0)
  -analyzeduration .D…… specify how many microseconds are analyzed to probe the input (from 0 to INT_MAX) (default 5e+006)
  -cryptokey .D…… decryption key
  -indexmem .D…… max memory used for timestamp index (per stream) (from 0 to INT_MAX) (default 1.04858e+006)
  -rtbufsize .D…… max memory used for buffering real-time frames (from 0 to INT_MAX) (default 3.04128e+006)
  -fdebug ED…… print specific debug info (default 0)
     ts ED……
  -max_delay ED…… maximum muxing or demuxing delay in microseconds (from -1 to INT_MAX) (default -1)
  -start_time_realtime E……. wall-clock time when stream begins (PTS==0) (from I64_MIN to I64_MAX) (default I64_MIN)
  -fpsprobesize .D…… number of frames used to probe fps (from -1 to 2.14748e+009) (default -1)
  -audio_preload E……. microseconds by which audio packets should be interleaved earlier (from 0 to 2.14748e+009) (default 0)
  -chunk_duration E……. microseconds for each chunk (from 0 to 2.14748e+009) (default 0)
  -chunk_size E……. size in bytes for each chunk (from 0 to 2.14748e+009) (default 0)
  -f_err_detect .D…… set error detection flags (deprecated; use err_detect, save via avconv) (default 1)
     crccheck .D…… verify embedded CRCs
     bitstream .D…… detect bitstream specification deviations
     buffer .D…… detect improper bitstream length
     explode .D…… abort decoding on minor error detection
     careful .D…… consider things that violate the spec, are fast to check and have not been seen in the wild as errors
     compliant .D…… consider all spec non compliancies as errors
     aggressive .D…… consider things that a sane encoder shouldn’t do as an error
  -err_detect .D…… set error detection flags (default 1)
     crccheck .D…… verify embedded CRCs
     bitstream .D…… detect bitstream specification deviations
     buffer .D…… detect improper bitstream length
     explode .D…… abort decoding on minor error detection
     careful .D…… consider things that violate the spec, are fast to check and have not been seen in the wild as errors
     compliant .D…… consider all spec non compliancies as errors
     aggressive .D…… consider things that a sane encoder shouldn’t do as an error
  -use_wallclock_as_timestamps .D…… use wallclock as timestamps (from 0 to 2.14748e+009) (default 0)
  -avoid_negative_ts E……. shift timestamps so they start at 0 (from -1 to 2) (default -1)
     auto E……. enabled when required by target format
     disabled E……. do not change timestamps
     make_zero E……. shift timestamps so they start at 0
     make_non_negative E……. shift timestamps so they are non negative
  -skip_initial_bytes .D…… set number of bytes to skip before reading header and frames (from 0 to 2.14748e+009) (default 0)
  -correct_ts_overflow .D…… correct single timestamp overflows (from 0 to 1) (default 1)
  -flush_packets E……. enable flushing of the I/O context after each packet (from 0 to 1) (default 1)
  -metadata_header_padding E……. set number of bytes to be written as padding in a metadata header (from -1 to INT_MAX) (default -1)
  -output_ts_offset E……. set output timestamp offset (default 0)
  -max_interleave_delta E……. maximum buffering duration for interleaving (from 0 to I64_MAX) (default 1e+007)

AVIOContext AVOptions:

URLContext AVOptions:

bluray AVOptions:
  -playlist .D…… (from -1 to 99999) (default -1)
  -angle .D…… (from 0 to 254) (default 0)
  -chapter .D…… (from 1 to 65534) (default 1)

crypto AVOptions:
  -key .D…… AES decryption key
  -iv .D…… AES decryption initialization vector

file AVOptions:
  -truncate E……. truncate existing files on write (from 0 to 1) (default 1)
  -blocksize E……. set I/O operation maximum block size (from 1 to INT_MAX) (default INT_MAX)

ftp AVOptions:
  -timeout ED…… set timeout of socket I/O operations (from -1 to INT_MAX) (default -1)
  -ftp-write-seekable E……. control seekability of connection during encoding (from 0 to 1) (default 0)
  -ftp-anonymous-password ED…… password for anonymous login. E-mail address should be used.

http AVOptions:
  -seekable .D…… control seekability of connection (from -1 to 1) (default -1)
  -chunked_post E……. use chunked transfer-encoding for posts (from 0 to 1) (default 1)
  -headers ED…… set custom HTTP headers, can override built in default headers
  -content_type ED…… set a specific content type for the POST messages
  -user_agent .D…… override User-Agent header (default “Lavf/55.37.100”)
  -user-agent .D…… override User-Agent header (default “Lavf/55.37.100”)
  -multiple_requests ED…… use persistent connections (from 0 to 1) (default 0)
  -post_data ED…… set custom HTTP post data
  -cookies .D…… set cookies to be sent in applicable future requests, use newline delimited Set-Cookie HTTP field value syntax
  -icy .D…… request ICY metadata (from 0 to 1) (default 0)
  -auth_type ED…… HTTP authentication type (from 0 to 1) (default 0)
     none ED…… No auth method set, autodetect
     basic ED…… HTTP basic authentication
  -send_expect_100 E……. Force sending an Expect: 100-continue header for POST (from 0 to 1) (default 0)
  -location ED…… The actual location of the data received
  -offset .D…… initial byte offset (from 0 to I64_MAX) (default 0)
  -end_offset .D…… try to limit the request to bytes preceding this offset (from 0 to I64_MAX) (default 0)

https AVOptions:
  -seekable .D…… control seekability of connection (from -1 to 1) (default -1)
  -chunked_post E……. use chunked transfer-encoding for posts (from 0 to 1) (default 1)
  -headers ED…… set custom HTTP headers, can override built in default headers
  -content_type ED…… set a specific content type for the POST messages
  -user_agent .D…… override User-Agent header (default “Lavf/55.37.100”)
  -user-agent .D…… override User-Agent header (default “Lavf/55.37.100”)
  -multiple_requests ED…… use persistent connections (from 0 to 1) (default 0)
  -post_data ED…… set custom HTTP post data
  -cookies .D…… set cookies to be sent in applicable future requests, use newline delimited Set-Cookie HTTP field value syntax
  -icy .D…… request ICY metadata (from 0 to 1) (default 0)
  -auth_type ED…… HTTP authentication type (from 0 to 1) (default 0)
     none ED…… No auth method set, autodetect
     basic ED…… HTTP basic authentication
  -send_expect_100 E……. Force sending an Expect: 100-continue header for POST (from 0 to 1) (default 0)
  -location ED…… The actual location of the data received
  -offset .D…… initial byte offset (from 0 to I64_MAX) (default 0)
  -end_offset .D…… try to limit the request to bytes preceding this offset (from 0 to I64_MAX) (default 0)

pipe AVOptions:
  -blocksize E……. set I/O operation maximum block size (from 1 to INT_MAX) (default INT_MAX)

srtp AVOptions:
  -srtp_out_suite E……. 
  -srtp_out_params E……. 
  -srtp_in_suite E……. 
  -srtp_in_params E…….

subfile AVOptions:
  -start .D…… start offset (from 0 to I64_MAX) (default 0)
  -end .D…… end offset (from 0 to I64_MAX) (default 0)

tcp AVOptions:
  -listen ED…… listen on port instead of connecting (from 0 to 1) (default 0)
  -timeout ED…… set timeout of socket I/O operations (from -1 to INT_MAX) (default -1)
  -listen_timeout ED…… set connection awaiting timeout (from -1 to INT_MAX) (default -1)

tls AVOptions:
  -ca_file ED…… Certificate Authority database file
  -cafile ED…… Certificate Authority database file
  -tls_verify ED…… Verify the peer certificate (from 0 to 1) (default 0)
  -cert_file ED…… Certificate file
  -key_file ED…… Private key file
  -listen ED…… Listen for incoming connections (from 0 to 1) (default 0)

udp AVOptions:
  -buffer_size ED…… set packet buffer size in bytes (from 0 to INT_MAX) (default 0)
  -localport ED…… set local port to bind to (from 0 to INT_MAX) (default 0)
  -localaddr ED…… choose local IP address (default “”)
  -pkt_size ED…… set size of UDP packets (from 0 to INT_MAX) (default 1472)
  -reuse ED…… explicitly allow or disallow reusing UDP sockets (from 0 to 1) (default 0)
  -ttl E……. set the time to live value (for multicast only) (from 0 to INT_MAX) (default 16)
  -connect ED…… set if connect() should be called on socket (from 0 to 1) (default 0)
  -fifo_size .D…… set the UDP receiving circular buffer size, expressed as a number of packets with size of 188 bytes (from 0 to INT_MAX) (default 28672)
  -overrun_nonfatal .D…… survive in case of UDP receiving circular buffer overrun (from 0 to 1) (default 0)
  -timeout .D…… set raise error timeout (only in read mode) (from 0 to INT_MAX) (default 0)

librtmp protocol AVOptions:
  -rtmp_app ED…… Name of application to connect to on the RTMP server
  -rtmp_playpath ED…… Stream identifier to play or to publish

librtmpe protocol AVOptions:
  -rtmp_app ED…… Name of application to connect to on the RTMP server
  -rtmp_playpath ED…… Stream identifier to play or to publish

librtmps protocol AVOptions:
  -rtmp_app ED…… Name of application to connect to on the RTMP server
  -rtmp_playpath ED…… Stream identifier to play or to publish

librtmpt protocol AVOptions:
  -rtmp_app ED…… Name of application to connect to on the RTMP server
  -rtmp_playpath ED…… Stream identifier to play or to publish

librtmpte protocol AVOptions:
  -rtmp_app ED…… Name of application to connect to on the RTMP server
  -rtmp_playpath ED…… Stream identifier to play or to publish

dshow indev AVOptions:
  -video_size .D…… set video size given a string such as 640×480 or hd720.
  -pixel_format .D…… set video pixel format (default none)
  -framerate .D…… set video frame rate
  -sample_rate .D…… set audio sample rate (from 0 to INT_MAX) (default 0)
  -sample_size .D…… set audio sample size (from 0 to 16) (default 0)
  -channels .D…… set number of audio channels, such as 1 or 2 (from 0 to INT_MAX) (default 0)
  -list_devices .D…… list available devices (from 0 to 1) (default 0)
     true .D…… 
     false .D…… 
  -list_options .D…… list available options for specified device (from 0 to 1) (default 0)
     true .D…… 
     false .D…… 
  -video_device_number .D…… set video device number for devices with same name (starts at 0) (from 0 to INT_MAX) (default 0)
  -audio_device_number .D…… set audio device number for devices with same name (starts at 0) (from 0 to INT_MAX) (default 0)
  -audio_buffer_size .D…… set audio device buffer latency size in milliseconds (default is the device’s default) (from 0 to INT_MAX) (default 0)

GDIgrab indev AVOptions:
  -draw_mouse .D…… draw the mouse pointer (from 0 to 1) (default 1)
  -show_region .D…… draw border around capture area (from 0 to 1) (default 0)
  -framerate .D…… set video frame rate (default “ntsc”)
  -video_size .D…… set video frame size
  -offset_x .D…… capture area x offset (from INT_MIN to INT_MAX) (default 0)
  -offset_y .D…… capture area y offset (from INT_MIN to INT_MAX) (default 0)

lavfi indev AVOptions:
  -graph .D…… set libavfilter graph
  -graph_file .D…… set libavfilter graph filename
  -dumpgraph .D…… dump graph to stderr

VFW indev AVOptions:
  -video_size .D…… A string describing frame size, such as 640×480 or hd720.
  -framerate .D…… (default “ntsc”)

Artworx Data Format demuxer AVOptions:
  -linespeed .D…… set simulated line speed (bytes per second) (from 1 to INT_MAX) (default 6000)
  -video_size .D…… set video size, such as 640×480 or hd720.
  -framerate .D…… set framerate (frames per second) (default “25”)

aqtdec AVOptions:
  -subfps .D…S.. set the movie frame rate (from 0 to INT_MAX) (default 25/1)

asf demuxer AVOptions:
  -no_resync_search .D…… Don’t try to resynchronize by looking for a certain optional start code (from 0 to 1) (default 0)

avi AVOptions:
  -use_odml .D…… use odml index (from -1 to 1) (default 1)

Binary text demuxer AVOptions:
  -linespeed .D…… set simulated line speed (bytes per second) (from 1 to INT_MAX) (default 6000)
  -video_size .D…… set video size, such as 640×480 or hd720.
  -framerate .D…… set framerate (frames per second) (default “25”)

cavsvideo demuxer AVOptions:
  -framerate .D…… (default “25”)

CDXL demuxer AVOptions:
  -sample_rate .D…… (from 1 to INT_MAX) (default 11025)
  -framerate .D……

concat demuxer AVOptions:
  -safe .D…… enable safe mode (from -1 to 1) (default -1)

dirac demuxer AVOptions:
  -framerate .D…… (default “25”)

dnxhd demuxer AVOptions:
  -framerate .D…… (default “25”)

flvdec AVOptions:
  -flv_metadata .D.V…. Allocate streams according to the onMetaData array (from 0 to 1) (default 0)

g729 demuxer AVOptions:
  -bit_rate .D…… (from 0 to INT_MAX) (default 0)

GIF demuxer AVOptions:
  -min_delay .D…… minimum valid delay between frames (in hundredths of second) (from 0 to 6000) (default 2)
  -default_delay .D…… default delay between frames (in hundredths of second) (from 0 to 6000) (default 10)
  -ignore_loop .D…… ignore loop setting (netscape extension) (from 0 to 1) (default 1)

gsm demuxer AVOptions:
  -sample_rate .D…… (from 1 to 6.50753e+007) (default 8000)

h261 demuxer AVOptions:
  -framerate .D…… (default “25”)

h263 demuxer AVOptions:
  -framerate .D…… (default “25”)

h264 demuxer AVOptions:
  -framerate .D…… (default “25”)

hevc demuxer AVOptions:
  -framerate .D…… (default “25”)

iCE Draw File demuxer AVOptions:
  -linespeed .D…… set simulated line speed (bytes per second) (from 1 to INT_MAX) (default 6000)
  -video_size .D…… set video size, such as 640×480 or hd720.
  -framerate .D…… set framerate (frames per second) (default “25”)

image2 demuxer AVOptions:
  -framerate .D…… set the video framerate (default “25”)
  -loop .D…… force loop over input file sequence (from 0 to 1) (default 0)
  -pattern_type .D…… set pattern type (from 0 to INT_MAX) (default 0)
     glob_sequence .D…… select glob/sequence pattern type
     glob .D…… select glob pattern type
     sequence .D…… select sequence pattern type
  -pixel_format .D…… set video pixel format
  -start_number .D…… set first number in the sequence (from 0 to INT_MAX) (default 0)
  -start_number_range .D…… set range for looking at the first sequence number (from 1 to INT_MAX) (default 5)
  -video_size .D…… set video size
  -frame_size .D…… force frame size in bytes (from 0 to INT_MAX) (default 0)
  -ts_from_file .D…… set frame timestamp from file’s one (from 0 to 2) (default 0)
     none .D…… none
     sec .D…… second precision
     ns .D…… nano second precision

image2pipe demuxer AVOptions:
  -framerate .D…… set the video framerate (default “25”)
  -loop .D…… force loop over input file sequence (from 0 to 1) (default 0)
  -pattern_type .D…… set pattern type (from 0 to INT_MAX) (default 0)
     glob_sequence .D…… select glob/sequence pattern type
     glob .D…… select glob pattern type
     sequence .D…… select sequence pattern type
  -pixel_format .D…… set video pixel format
  -start_number .D…… set first number in the sequence (from 0 to INT_MAX) (default 0)
  -start_number_range .D…… set range for looking at the first sequence number (from 1 to INT_MAX) (default 5)
  -video_size .D…… set video size
  -frame_size .D…… force frame size in bytes (from 0 to INT_MAX) (default 0)
  -ts_from_file .D…… set frame timestamp from file’s one (from 0 to 2) (default 0)
     none .D…… none
     sec .D…… second precision
     ns .D…… nano second precision

ingenient demuxer AVOptions:
  -framerate .D…… (default “25”)

m4v demuxer AVOptions:
  -framerate .D…… (default “25”)

microdvddec AVOptions:
  -subfps .D…S.. set the movie frame rate fallback (from 0 to INT_MAX) (default 0/1)

mjpeg demuxer AVOptions:
  -framerate .D…… (default “25”)

mov,mp4,m4a,3gp,3g2,mj2 AVOptions:
  -use_absolute_path .D.V…. allow using absolute path when opening alias, this is a possible security issue (from 0 to 1) (default 0)
  -ignore_editlist .D.V…. (from 0 to 1) (default 0)

mp3 AVOptions:
  -usetoc .D…… use table of contents (from -1 to 1) (default -1)

mpegts demuxer AVOptions:
  -fix_teletext_pts .D…… Try to fix pts values of dvb teletext streams. (from 0 to 1) (default 1)
  -ts_packetsize .D….XR Output option carrying the raw packet size. (from 0 to 0) (default 0)

mpegtsraw demuxer AVOptions:
  -compute_pcr .D…… Compute exact PCR for each transport stream packet. (from 0 to 1) (default 0)
  -ts_packetsize .D….XR Output option carrying the raw packet size. (from 0 to 0) (default 0)

mpegvideo demuxer AVOptions:
  -framerate .D…… (default “25”)

alaw demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

mulaw demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

f64be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

f64le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

f32be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

f32le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

s32be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

s32le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

s24be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

s24le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

s16be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

s16le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

s8 demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

u32be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

u32le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

u24be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

u24le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

u16be demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

u16le demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

u8 demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 44100)
  -channels .D…… (from 0 to INT_MAX) (default 1)

rawvideo demuxer AVOptions:
  -video_size .D…… set frame size
  -pixel_format .D…… set pixel format (default “yuv420p”)
  -framerate .D…… set frame rate (default “25”)

RTP demuxer AVOptions:
  -rtp_flags .D…… set RTP flags (default 0)
     filter_src .D…… only receive packets from the negotiated peer IP
  -reorder_queue_size .D…… set number of packets to buffer for handling of reordered packets (from -1 to INT_MAX) (default -1)

RTSP demuxer AVOptions:
  -initial_pause .D…… do not start playing the stream immediately (from 0 to 1) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -rtsp_transport ED…… set RTSP transport protocols (default 0)
     udp ED…… UDP
     tcp ED…… TCP
     udp_multicast .D…… UDP multicast
     http .D…… HTTP tunneling
  -rtsp_flags .D…… set RTSP flags (default 0)
     filter_src .D…… only receive packets from the negotiated peer IP
     listen .D…… wait for incoming connections
     prefer_tcp ED…… try RTP via TCP first, if available
  -allowed_media_types .D…… set media types to accept from the server (default 7)
     video .D…… Video
     audio .D…… Audio
     data .D…… Data
  -min_port ED…… set minimum local UDP port (from 0 to 65535) (default 5000)
  -max_port ED…… set maximum local UDP port (from 0 to 65535) (default 65000)
  -timeout .D…… set maximum timeout (in seconds) to wait for incoming connections (-1 is infinite, imply flag listen) (from INT_MIN to INT_MAX) (default -1)
  -stimeout .D…… set timeout (in micro seconds) of socket TCP I/O operations (from INT_MIN to INT_MAX) (default 0)
  -reorder_queue_size .D…… set number of packets to buffer for handling of reordered packets (from -1 to INT_MAX) (default -1)
  -user-agent .D…… override User-Agent header (default “Lavf55.37.100”)

sbg_demuxer AVOptions:
  -sample_rate .D…… (from 0 to INT_MAX) (default 0)
  -frame_size .D…… (from 0 to INT_MAX) (default 0)
  -max_file_size .D…… (from 0 to INT_MAX) (default 5e+006)

SDP demuxer AVOptions:
  -sdp_flags .D…… SDP flags (default 0)
     filter_src .D…… only receive packets from the negotiated peer IP
     custom_io .D…… use custom I/O
     rtcp_to_source .D…… send RTCP packets to the source address of received packets
  -allowed_media_types .D…… set media types to accept from the server (default 7)
     video .D…… Video
     audio .D…… Audio
     data .D…… Data
  -reorder_queue_size .D…… set number of packets to buffer for handling of reordered packets (from -1 to INT_MAX) (default -1)

tedcaptions_demuxer AVOptions:
  -start_time .D…S.. set the start time (offset) of the subtitles, in ms (from I64_MIN to I64_MAX) (default 15000)

TTY demuxer AVOptions:
  -chars_per_frame .D…… (from 1 to INT_MAX) (default 6000)
  -video_size .D…… A string describing frame size, such as 640×480 or hd720.
  -framerate .D…… (default “25”)

vc1 demuxer AVOptions:
  -framerate .D…… (default “25”)

WAV demuxer AVOptions:
  -ignore_length .D…… Ignore length (from 0 to 1) (default 0)

WebVTT demuxer AVOptions:

eXtended BINary text (XBIN) demuxer AVOptions:
  -linespeed .D…… set simulated line speed (bytes per second) (from 1 to INT_MAX) (default 6000)
  -video_size .D…… set video size, such as 640×480 or hd720.
  -framerate .D…… set framerate (frames per second) (default “25”)

ModPlug demuxer AVOptions:
  -noise_reduction .D…… Enable noise reduction 0(off)-1(on) (from 0 to 1) (default 0)
  -reverb_depth .D…… Reverb level 0(quiet)-100(loud) (from 0 to 100) (default 0)
  -reverb_delay .D…… Reverb delay in ms, usually 40-200ms (from 0 to INT_MAX) (default 0)
  -bass_amount .D…… XBass level 0(quiet)-100(loud) (from 0 to 100) (default 0)
  -bass_range .D…… XBass cutoff in Hz 10-100 (from 0 to 100) (default 0)
  -surround_depth .D…… Surround level 0(quiet)-100(heavy) (from 0 to 100) (default 0)
  -surround_delay .D…… Surround delay in ms, usually 5-40ms (from 0 to INT_MAX) (default 0)
  -max_size .D…… Max file size supported (in bytes). Default is 5MB. Set to 0 for no limit (not recommended) (from 0 to 1.04858e+008) (default 5.24288e+006)
  -video_stream_expr .D…… Color formula
  -video_stream .D…… Make demuxer output a video stream (from 0 to 1) (default 0)
  -video_stream_w .D…… Video stream width in char (one char = 8×8px) (from 20 to 512) (default 30)
  -video_stream_h .D…… Video stream height in char (one char = 8×8px) (from 20 to 512) (default 30)
  -video_stream_ptxt .D…… Print speed, tempo, order, … in video stream (from 0 to 1) (default 1)

caca_outdev AVOptions:
  -window_size E……. set window forced size
  -window_title E……. set window title
  -driver E……. set display driver
  -algorithm E……. set dithering algorithm (default “default”)
  -antialias E……. set antialias method (default “default”)
  -charset E……. set charset used to render output (default “default”)
  -color E……. set color used to render output (default “default”)
  -list_drivers E……. list available drivers (from 0 to 1) (default 0)
     true E…….
     false E…….
  -list_dither E……. list available dither options
     algorithms E…….
     antialiases E…….
     charsets E…….
     colors E…….

sdl outdev AVOptions:
  -window_title E……. set SDL window title
  -icon_title E……. set SDL iconified window title
  -window_size E……. set SDL window forced size
  -window_fullscreen E……. set SDL window fullscreen (from INT_MIN to INT_MAX) (default 0)

ADTS muxer AVOptions:
  -write_apetag E……. Enable APE tag writing (from 0 to 1) (default 0)

AIFF muxer AVOptions:
  -write_id3v2 E……. Enable ID3 tags writing. (from 0 to 1) (default 0)
  -id3v2_version E……. Select ID3v2 version to write. Currently 3 and 4 are supported. (from 3 to 4) (default 4)

AST muxer AVOptions:
  -loopstart E……. Loopstart position in milliseconds. (from -1 to INT_MAX) (default -1)
  -loopend E……. Loopend position in milliseconds. (from 0 to INT_MAX) (default 0)

f4v muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

flac muxer AVOptions:
  -write_header E……. Write the file header (from 0 to 1) (default 1)

frame hash encoder class AVOptions:
  -hash E……. set hash to use (default “md5”)

GIF muxer AVOptions:
  -loop E……. Number of times to loop the output: -1 – no loop, 0 – infinite loop (from -1 to 65535) (default 0)
  -final_delay E……. Force delay (in centiseconds) after the last frame (from -1 to 65535) (default -1)

HDS muxer AVOptions:
  -window_size E……. number of fragments kept in the manifest (from 0 to INT_MAX) (default 0)
  -extra_window_size E……. number of fragments kept outside of the manifest before removing from disk (from 0 to INT_MAX) (default 5)
  -min_frag_duration E……. minimum fragment duration (in microseconds) (from 0 to INT_MAX) (default 1e+007)
  -remove_at_exit E……. remove all fragments when finished (from 0 to 1) (default 0)

hls muxer AVOptions:
  -start_number E……. set first number in the sequence (from 0 to I64_MAX) (default 0)
  -hls_time E……. set segment length in seconds (from 0 to FLT_MAX) (default 2)
  -hls_list_size E……. set maximum number of playlist entries (from 0 to INT_MAX) (default 5)
  -hls_wrap E……. set number after which the index wraps (from 0 to INT_MAX) (default 0)

image2 muxer AVOptions:
  -updatefirst E……. continuously overwrite one file (from 0 to 1) (default 0)
  -update E……. continuously overwrite one file (from 0 to 1) (default 0)
  -start_number E……. set first number in the sequence (from 0 to INT_MAX) (default 1)
  -strftime E……. use strftime for filename (from 0 to 1) (default 0)

ipod muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

ismv muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

LATM/LOAS muxer AVOptions:
  -smc-interval E……. StreamMuxConfig interval. (from 1 to 65535) (default 20)

hash encoder class AVOptions:
  -hash E……. set hash to use (default “md5”)

matroska muxer AVOptions:
  -reserve_index_space E……. Reserve a given amount of space (in bytes) at the beginning of the file for the index (cues). (from 0 to INT_MAX) (default 0)
  -cluster_size_limit E……. Store at most the provided amount of bytes in a cluster. (from -1 to INT_MAX) (default -1)
  -cluster_time_limit E……. Store at most the provided number of milliseconds in a cluster. (from -1 to I64_MAX) (default -1)

matroska audio muxer AVOptions:
  -reserve_index_space E……. Reserve a given amount of space (in bytes) at the beginning of the file for the index (cues). (from 0 to INT_MAX) (default 0)
  -cluster_size_limit E……. Store at most the provided amount of bytes in a cluster. (from -1 to INT_MAX) (default -1)
  -cluster_time_limit E……. Store at most the provided number of milliseconds in a cluster. (from -1 to I64_MAX) (default -1)

mov muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

MP3 muxer AVOptions:
  -id3v2_version E……. Select ID3v2 version to write. Currently 3 and 4 are supported. (from 0 to 4) (default 4)
  -write_id3v1 E……. Enable ID3v1 writing. ID3v1 tags are written in UTF-8 which may not be supported by most software. (from 0 to 1) (default 0)
  -write_xing E……. Write the Xing header containing file duration. (from 0 to 1) (default 1)

mp4 muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

mpeg muxer AVOptions:
  -muxrate E……. (from 0 to 1.67772e+009) (default 0)
  -preload E……. Initial demux-decode delay in microseconds. (from 0 to INT_MAX) (default 500000)

vcd muxer AVOptions:
  -muxrate E……. (from 0 to 1.67772e+009) (default 0)
  -preload E……. Initial demux-decode delay in microseconds. (from 0 to INT_MAX) (default 500000)

dvd muxer AVOptions:
  -muxrate E……. (from 0 to 1.67772e+009) (default 0)
  -preload E……. Initial demux-decode delay in microseconds. (from 0 to INT_MAX) (default 500000)

svcd muxer AVOptions:
  -muxrate E……. (from 0 to 1.67772e+009) (default 0)
  -preload E……. Initial demux-decode delay in microseconds. (from 0 to INT_MAX) (default 500000)

vob muxer AVOptions:
  -muxrate E……. (from 0 to 1.67772e+009) (default 0)
  -preload E……. Initial demux-decode delay in microseconds. (from 0 to INT_MAX) (default 500000)

MPEGTS muxer AVOptions:
  -mpegts_transport_stream_id E……. Set transport_stream_id field. (from 1 to 65535) (default 1)
  -mpegts_original_network_id E……. Set original_network_id field. (from 1 to 65535) (default 1)
  -mpegts_service_id E……. Set service_id field. (from 1 to 65535) (default 1)
  -mpegts_pmt_start_pid E……. Set the first pid of the PMT. (from 16 to 7936) (default 4096)
  -mpegts_start_pid E……. Set the first pid. (from 256 to 3840) (default 256)
  -mpegts_m2ts_mode E……. Enable m2ts mode. (from -1 to 1) (default -1)
  -muxrate E……. (from 0 to INT_MAX) (default 1)
  -pes_payload_size E……. Minimum PES packet payload in bytes (from 0 to INT_MAX) (default 2930)
  -mpegts_flags E……. MPEG-TS muxing flags (default 0)
     resend_headers E……. Reemit PAT/PMT before writing the next packet
     latm E……. Use LATM packetization for AAC
  -resend_headers E……. Reemit PAT/PMT before writing the next packet (from 0 to INT_MAX) (default 0)
  -mpegts_copyts E……. don’t offset dts/pts (from -1 to 1) (default -1)
  -tables_version E……. set PAT, PMT and SDT version (from 0 to 31) (default 0)

Ogg audio muxer AVOptions:
  -oggpagesize E……. Set preferred Ogg page size. (from 0 to 65025) (default 0)
  -pagesize E……. preferred page size in bytes (deprecated) (from 0 to 65025) (default 0)
  -page_duration E……. preferred page duration, in microseconds (from 0 to I64_MAX) (default 1e+006)

Ogg muxer AVOptions:
  -oggpagesize E……. Set preferred Ogg page size. (from 0 to 65025) (default 0)
  -pagesize E……. preferred page size in bytes (deprecated) (from 0 to 65025) (default 0)
  -page_duration E……. preferred page duration, in microseconds (from 0 to I64_MAX) (default 1e+006)

Opus muxer AVOptions:
  -oggpagesize E……. Set preferred Ogg page size. (from 0 to 65025) (default 0)
  -pagesize E……. preferred page size in bytes (deprecated) (from 0 to 65025) (default 0)
  -page_duration E……. preferred page duration, in microseconds (from 0 to I64_MAX) (default 1e+006)

psp muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

RTP muxer AVOptions:
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -payload_type E……. Specify RTP payload type (from -1 to 127) (default -1)
  -ssrc E……. Stream identifier (from INT_MIN to INT_MAX) (default 0)
  -cname E……. CNAME to include in RTCP SR packets
  -seq E……. Starting sequence number (from -1 to 65535) (default -1)

RTSP muxer AVOptions:
  -initial_pause .D…… do not start playing the stream immediately (from 0 to 1) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -rtsp_transport ED…… set RTSP transport protocols (default 0)
     udp ED…… UDP
     tcp ED…… TCP
     udp_multicast .D…… UDP multicast
     http .D…… HTTP tunneling
  -rtsp_flags .D…… set RTSP flags (default 0)
     filter_src .D…… only receive packets from the negotiated peer IP
     listen .D…… wait for incoming connections
     prefer_tcp ED…… try RTP via TCP first, if available
  -allowed_media_types .D…… set media types to accept from the server (default 7)
     video .D…… Video
     audio .D…… Audio
     data .D…… Data
  -min_port ED…… set minimum local UDP port (from 0 to 65535) (default 5000)
  -max_port ED…… set maximum local UDP port (from 0 to 65535) (default 65000)
  -timeout .D…… set maximum timeout (in seconds) to wait for incoming connections (-1 is infinite, imply flag listen) (from INT_MIN to INT_MAX) (default -1)
  -stimeout .D…… set timeout (in micro seconds) of socket TCP I/O operations (from INT_MIN to INT_MAX) (default 0)
  -reorder_queue_size .D…… set number of packets to buffer for handling of reordered packets (from -1 to INT_MAX) (default -1)
  -user-agent .D…… override User-Agent header (default “Lavf55.37.100”)

segment muxer AVOptions:
  -reference_stream E……. set reference stream (default “auto”)
  -segment_format E……. set container format used for the segments
  -segment_list E……. set the segment list filename
  -segment_list_flags E……. set flags affecting segment list generation (default 1)
     cache E……. allow list caching
     live E……. enable live-friendly list generation (useful for HLS)
  -segment_list_size E……. set the maximum number of playlist entries (from 0 to INT_MAX) (default 0)
  -segment_list_entry_prefix E……. set prefix to prepend to each list entry filename
  -segment_list_type E……. set the segment list type (from -1 to 4) (default -1)
     flat E……. flat format
     csv E……. csv format
     ext E……. extended format
     ffconcat E……. ffconcat format
     m3u8 E……. M3U8 format
     hls E……. Apple HTTP Live Streaming compatible
  -segment_time E……. set segment duration
  -segment_time_delta E……. set approximation value used for the segment times (default 0)
  -segment_times E……. set segment split time points
  -segment_frames E……. set segment split frame numbers
  -segment_wrap E……. set number after which the index wraps (from 0 to INT_MAX) (default 0)
  -segment_start_number E……. set the sequence number of the first segment (from 0 to INT_MAX) (default 0)
  -segment_wrap_number E……. set the number of wrap before the first segment (from 0 to INT_MAX) (default 0)
  -individual_header_trailer E……. write header/trailer to each segment (from 0 to 1) (default 1)
  -write_header_trailer E……. write a header to the first segment and a trailer to the last one (from 0 to 1) (default 1)
  -reset_timestamps E……. reset timestamps at the begin of each segment (from 0 to 1) (default 0)
  -initial_offset E……. set initial timestamp offset (default 0)

stream_segment muxer AVOptions:
  -reference_stream E……. set reference stream (default “auto”)
  -segment_format E……. set container format used for the segments
  -segment_list E……. set the segment list filename
  -segment_list_flags E……. set flags affecting segment list generation (default 1)
     cache E……. allow list caching
     live E……. enable live-friendly list generation (useful for HLS)
  -segment_list_size E……. set the maximum number of playlist entries (from 0 to INT_MAX) (default 0)
  -segment_list_entry_prefix E……. set prefix to prepend to each list entry filename
  -segment_list_type E……. set the segment list type (from -1 to 4) (default -1)
     flat E……. flat format
     csv E……. csv format
     ext E……. extended format
     ffconcat E……. ffconcat format
     m3u8 E……. M3U8 format
     hls E……. Apple HTTP Live Streaming compatible
  -segment_time E……. set segment duration
  -segment_time_delta E……. set approximation value used for the segment times (default 0)
  -segment_times E……. set segment split time points
  -segment_frames E……. set segment split frame numbers
  -segment_wrap E……. set number after which the index wraps (from 0 to INT_MAX) (default 0)
  -segment_start_number E……. set the sequence number of the first segment (from 0 to INT_MAX) (default 0)
  -segment_wrap_number E……. set the number of wrap before the first segment (from 0 to INT_MAX) (default 0)
  -individual_header_trailer E……. write header/trailer to each segment (from 0 to 1) (default 1)
  -write_header_trailer E……. write a header to the first segment and a trailer to the last one (from 0 to 1) (default 1)
  -reset_timestamps E……. reset timestamps at the begin of each segment (from 0 to 1) (default 0)
  -initial_offset E……. set initial timestamp offset (default 0)

smooth streaming muxer AVOptions:
  -window_size E……. number of fragments kept in the manifest (from 0 to INT_MAX) (default 0)
  -extra_window_size E……. number of fragments kept outside of the manifest before removing from disk (from 0 to INT_MAX) (default 5)
  -lookahead_count E……. number of lookahead fragments (from 0 to INT_MAX) (default 2)
  -min_frag_duration E……. minimum fragment duration (in microseconds) (from 0 to INT_MAX) (default 5e+006)
  -remove_at_exit E……. remove all fragments when finished (from 0 to 1) (default 0)

spdif AVOptions:
  -spdif_flags E……. IEC 61937 encapsulation flags (default 0)
     be E……. output in big-endian format (for use as s16be)
  -dtshd_rate E……. mux complete DTS frames in HD mode at the specified IEC958 rate (in Hz, default 0=disabled) (from 0 to 768000) (default 0)
  -dtshd_fallback_time E……. min secs to strip HD for after an overflow (-1: till the end, default 60) (from -1 to INT_MAX) (default 60)

Speex muxer AVOptions:
  -oggpagesize E……. Set preferred Ogg page size. (from 0 to 65025) (default 0)
  -pagesize E……. preferred page size in bytes (deprecated) (from 0 to 65025) (default 0)
  -page_duration E……. preferred page duration, in microseconds (from 0 to I64_MAX) (default 1e+006)

tg2 muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

tgp muxer AVOptions:
  -movflags E……. MOV muxer flags (default 0)
     rtphint E……. Add RTP hint tracks
     empty_moov E……. Make the initial moov atom empty (not supported by QuickTime)
     frag_keyframe E……. Fragment at video keyframes
     separate_moof E……. Write separate moof/mdat atoms for each track
     frag_custom E……. Flush fragments on caller requests
     isml E……. Create a live smooth streaming feed (for pushing to a publishing point)
     faststart E……. Run a second pass to put the index (moov atom) at the beginning of the file
     omit_tfhd_offset E……. Omit the base data offset in tfhd atoms
  -moov_size E……. maximum moov size so it can be placed at the begin (from 0 to INT_MAX) (default 0)
  -rtpflags E……. RTP muxer flags (default 0)
     latm E……. Use MP4A-LATM packetization instead of MPEG4-GENERIC for AAC
     rfc2190 E……. Use RFC 2190 packetization instead of RFC 4629 for H.263
     skip_rtcp E……. Don’t send RTCP sender reports
     h264_mode0 E……. Use mode 0 for H264 in RTP
     send_bye E……. Send RTCP BYE packets when finishing
  -skip_iods E……. Skip writing iods atom. (from 0 to 1) (default 1)
  -iods_audio_profile E……. iods audio profile atom. (from -1 to 255) (default -1)
  -iods_video_profile E……. iods video profile atom. (from -1 to 255) (default -1)
  -frag_duration E……. Maximum fragment duration (from 0 to INT_MAX) (default 0)
  -min_frag_duration E……. Minimum fragment duration (from 0 to INT_MAX) (default 0)
  -frag_size E……. Maximum fragment size (from 0 to INT_MAX) (default 0)
  -ism_lookahead E……. Number of lookahead entries for ISM files (from 0 to INT_MAX) (default 0)
  -use_editlist E……. use edit list (from -1 to 1) (default -1)
  -video_track_timescale E……. set timescale of all video tracks (from 0 to INT_MAX) (default 0)
  -brand E……. Override major brand

WAV muxer AVOptions:
  -write_bext E……. Write BEXT chunk. (from 0 to 1) (default 0)
  -rf64 E……. Use RF64 header rather than RIFF for large files. (from -1 to 1) (default 0)
     auto E……. Write RF64 header if file grows large enough.
     always E……. Always write RF64 header regardless of file size.
     never E……. Never write RF64 header regardless of file size.

webm muxer AVOptions:
  -reserve_index_space E……. Reserve a given amount of space (in bytes) at the beginning of the file for the index (cues). (from 0 to INT_MAX) (default 0)
  -cluster_size_limit E……. Store at most the provided amount of bytes in a cluster. (from -1 to INT_MAX) (default -1)
  -cluster_time_limit E……. Store at most the provided number of milliseconds in a cluster. (from -1 to I64_MAX) (default -1)

SWScaler AVOptions:
  -sws_flags E..V…. scaler flags (default 4)
     fast_bilinear E..V…. fast bilinear
     bilinear E..V…. bilinear
     bicubic E..V…. bicubic
     experimental E..V…. experimental
     neighbor E..V…. nearest neighbor
     area E..V…. averaging area
     bicublin E..V…. luma bicubic, chroma bilinear
     gauss E..V…. gaussian
     sinc E..V…. sinc
     lanczos E..V…. lanczos
     spline E..V…. natural bicubic spline
     print_info E..V…. print info
     accurate_rnd E..V…. accurate rounding
     full_chroma_int E..V…. full chroma interpolation
     full_chroma_inp E..V…. full chroma input
     bitexact E..V…. 
     error_diffusion E..V…. error diffusion dither
  -srcw E..V…. source width (from 1 to INT_MAX) (default 16)
  -srch E..V…. source height (from 1 to INT_MAX) (default 16)
  -dstw E..V…. destination width (from 1 to INT_MAX) (default 16)
  -dsth E..V…. destination height (from 1 to INT_MAX) (default 16)
  -src_format E..V…. source format (from 0 to 332) (default 0)
  -dst_format E..V…. destination format (from 0 to 332) (default 0)
  -src_range E..V…. source range (from 0 to 1) (default 0)
  -dst_range E..V…. destination range (from 0 to 1) (default 0)
  -param0 E..V…. scaler param 0 (from INT_MIN to INT_MAX) (default 123456)
  -param1 E..V…. scaler param 1 (from INT_MIN to INT_MAX) (default 123456)
  -src_v_chr_pos E..V…. source vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
  -src_h_chr_pos E..V…. source horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
  -dst_v_chr_pos E..V…. destination vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
  -dst_h_chr_pos E..V…. destination horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
  -sws_dither E..V…. set dithering algorithm (from 0 to 6) (default 1)
     auto E..V…. leave choice to sws
     bayer E..V…. bayer dither
     ed E..V…. error diffusion
     a_dither E..V…. arithmetic addition dither
     x_dither E..V…. arithmetic xor dither

SWResampler AVOptions:
  -ich ….A… set input channel count (from 0 to 32) (default 0)
  -in_channel_count ….A… set input channel count (from 0 to 32) (default 0)
  -och ….A… set output channel count (from 0 to 32) (default 0)
  -out_channel_count ….A… set output channel count (from 0 to 32) (default 0)
  -uch ….A… set used channel count (from 0 to 32) (default 0)
  -used_channel_count ….A… set used channel count (from 0 to 32) (default 0)
  -isr ….A… set input sample rate (from 0 to INT_MAX) (default 0)
  -in_sample_rate ….A… set input sample rate (from 0 to INT_MAX) (default 0)
  -osr ….A… set output sample rate (from 0 to INT_MAX) (default 0)
  -out_sample_rate ….A… set output sample rate (from 0 to INT_MAX) (default 0)
  -isf ….A… set input sample format (default none)
  -in_sample_fmt ….A… set input sample format (default none)
  -osf ….A… set output sample format (default none)
  -out_sample_fmt ….A… set output sample format (default none)
  -tsf ….A… set internal sample format (default none)
  -internal_sample_fmt ….A… set internal sample format (default none)
  -icl ….A… set input channel layout (default 0×0)
  -in_channel_layout ….A… set input channel layout (default 0×0)
  -ocl ….A… set output channel layout (default 0×0)
  -out_channel_layout ….A… set output channel layout (default 0×0)
  -clev ….A… set center mix level (from -32 to 32) (default 0.707107)
  -center_mix_level ….A… set center mix level (from -32 to 32) (default 0.707107)
  -slev ….A… set surround mix level (from -32 to 32) (default 0.707107)
  -surround_mix_level ….A… set surround mix Level (from -32 to 32) (default 0.707107)
  -lfe_mix_level ….A… set LFE mix level (from -32 to 32) (default 0)
  -rmvol ….A… set rematrix volume (from -1000 to 1000) (default 1)
  -rematrix_volume ….A… set rematrix volume (from -1000 to 1000) (default 1)
  -rematrix_maxval ….A… set rematrix maxval (from 0 to 1000) (default 0)
  -flags ….A… set flags (default 0)
     res ….A… force resampling
  -swr_flags ….A… set flags (default 0)
     res ….A… force resampling
  -dither_scale ….A… set dither scale (from 0 to INT_MAX) (default 1)
  -dither_method ….A… set dither method (from 0 to 71) (default 0)
     rectangular ….A… select rectangular dither
     triangular ….A… select triangular dither
     triangular_hp ….A… select triangular dither with high pass
     lipshitz ….A… select lipshitz noise shaping dither
     shibata ….A… select shibata noise shaping dither
     low_shibata ….A… select low shibata noise shaping dither
     high_shibata ….A… select high shibata noise shaping dither
     f_weighted ….A… select f-weighted noise shaping dither
     modified_e_weighted ….A… select modified-e-weighted noise shaping dither
     improved_e_weighted ….A… select improved-e-weighted noise shaping dither
  -filter_size ….A… set swr resampling filter size (from 0 to INT_MAX) (default 32)
  -phase_shift ….A… set swr resampling phase shift (from 0 to 24) (default 10)
  -linear_interp ….A… enable linear interpolation (from 0 to 1) (default 0)
  -cutoff ….A… set cutoff frequency ratio (from 0 to 1) (default 0)
  -resample_cutoff ….A… set cutoff frequency ratio (from 0 to 1) (default 0)
  -resampler ….A… set resampling Engine (from 0 to 1) (default 0)
     swr ….A… select SW Resampler
     soxr ….A… select SoX Resampler
  -precision ….A… set soxr resampling precision (in bits) (from 15 to 33) (default 20)
  -cheby ….A… enable soxr Chebyshev passband & higher-precision irrational ratio approximation (from 0 to 1) (default 0)
  -min_comp ….A… set minimum difference between timestamps and audio data (in seconds) below which no timestamp compensation of either kind is applied (from 0 to FLT_MAX) (default FLT_MAX)
  -min_hard_comp ….A… set minimum difference between timestamps and audio data (in seconds) to trigger padding/trimming the data. (from 0 to INT_MAX) (default 0.1)
  -comp_duration ….A… set duration (in seconds) over which data is stretched/squeezed to make it match the timestamps. (from 0 to INT_MAX) (default 1)
  -max_soft_comp ….A… set maximum factor by which data is stretched/squeezed to make it match the timestamps. (from INT_MIN to INT_MAX) (default 0)
  -async ….A… simplified 1 parameter audio timestamp matching, 0(disabled), 1(filling and trimming), >1(maximum stretch/squeeze in samples per second) (from INT_MIN to INT_MAX) (default 0)
  -first_pts ….A… Assume the first pts should be this value (in samples). (from I64_MIN to I64_MAX) (default I64_MIN)
  -matrix_encoding ….A… set matrixed stereo encoding (from 0 to 6) (default 0)
     none ….A… select none
     dolby ….A… select Dolby
     dplii ….A… select Dolby Pro Logic II
  -filter_type ….A… select swr filter type (from 0 to 2) (default 2)
     cubic ….A… select cubic
     blackman_nuttall ….A… select Blackman Nuttall Windowed Sinc
     kaiser ….A… select Kaiser Windowed Sinc
  -kaiser_beta ….A… set swr Kaiser Window Beta (from 2 to 16) (default 9)
  -output_sample_bits ….A… set swr number of output sample bits (from 0 to 64) (default 0)

AVFilter AVOptions:
  thread_type ..F….. Allowed thread types (default 1)
  enable ..F….. set enable expression

aconvert AVOptions:
  sample_fmt ..F.A… 
  channel_layout ..F.A…

adelay AVOptions:
  delays ..F.A… set list of delays for each channel

aecho AVOptions:
  in_gain ..F.A… set signal input gain (from 0 to 1) (default 0.6)
  out_gain ..F.A… set signal output gain (from 0 to 1) (default 0.3)
  delays ..F.A… set list of signal delays (default “1000”)
  decays ..F.A… set list of signal decays (default “0.5”)

aeval AVOptions:
  exprs ..F.A… set the ‘|’-separated list of channels expressions
  channel_layout ..F.A… set channel layout
  c ..F.A… set channel layout

afade AVOptions:
  type ..F.A… set the fade direction (from 0 to 1) (default 0)
     in ..F.A… fade-in
     out ..F.A… fade-out
  t ..F.A… set the fade direction (from 0 to 1) (default 0)
     in ..F.A… fade-in
     out ..F.A… fade-out
  start_sample ..F.A… set number of first sample to start fading (from 0 to I64_MAX) (default 0)
  ss ..F.A… set number of first sample to start fading (from 0 to I64_MAX) (default 0)
  nb_samples ..F.A… set number of samples for fade duration (from 1 to INT_MAX) (default 44100)
  ns ..F.A… set number of samples for fade duration (from 1 to INT_MAX) (default 44100)
  start_time ..F.A… set time to start fading (default 0)
  st ..F.A… set time to start fading (default 0)
  duration ..F.A… set fade duration (default 0)
  d ..F.A… set fade duration (default 0)
  curve ..F.A… set fade curve type (from 0 to 9) (default 0)
     tri ..F.A… linear slope
     qsin ..F.A… quarter of sine wave
     esin ..F.A… exponential sine wave
     hsin ..F.A… half of sine wave
     log ..F.A… logarithmic
     par ..F.A… inverted parabola
     qua ..F.A… quadratic
     cub ..F.A… cubic
     squ ..F.A… square root
     cbr ..F.A… cubic root
  c ..F.A… set fade curve type (from 0 to 9) (default 0)
     tri ..F.A… linear slope
     qsin ..F.A… quarter of sine wave
     esin ..F.A… exponential sine wave
     hsin ..F.A… half of sine wave
     log ..F.A… logarithmic
     par ..F.A… inverted parabola
     qua ..F.A… quadratic
     cub ..F.A… cubic
     squ ..F.A… square root
     cbr ..F.A… cubic root

aformat AVOptions:
  sample_fmts ..F.A… A comma-separated list of sample formats.
  sample_rates ..F.A… A comma-separated list of sample rates.
  channel_layouts ..F.A… A comma-separated list of channel layouts.

ainterleave AVOptions:
  nb_inputs ..F.A… set number of inputs (from 1 to INT_MAX) (default 2)
  n ..F.A… set number of inputs (from 1 to INT_MAX) (default 2)

allpass AVOptions:
  frequency ..F.A… set central frequency (from 0 to 999999) (default 3000)
  f ..F.A… set central frequency (from 0 to 999999) (default 3000)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 1)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set filter-width (from 0 to 99999) (default 707.1)
  w ..F.A… set filter-width (from 0 to 99999) (default 707.1)

amerge AVOptions:
  inputs ..F.A… specify the number of inputs (from 2 to 32) (default 2)

amix AVOptions:
  inputs ..F.A… Number of inputs. (from 1 to 32) (default 2)
  duration ..F.A… How to determine the end-of-stream. (from 0 to 2) (default 0)
     longest ..F.A… Duration of longest input.
     shortest ..F.A… Duration of shortest input.
     first ..F.A… Duration of first input.
  dropout_transition ..F.A… Transition time, in seconds, for volume renormalization when an input stream ends. (from 0 to INT_MAX) (default 2)

apad AVOptions:
  packet_size ..F.A… set silence packet size (from 0 to INT_MAX) (default 4096)
  pad_len ..F.A… number of samples of silence to add (from 0 to I64_MAX) (default 0)
  whole_len ..F.A… target number of samples in the audio stream (from 0 to I64_MAX) (default 0)

aperms AVOptions:
  mode ..FVA… select permissions mode (from 0 to 4) (default 0)
     none ..FVA… do nothing
     ro ..FVA… set all output frames read-only
     rw ..FVA… set all output frames writable
     toggle ..FVA… switch permissions
     random ..FVA… set permissions randomly
  seed ..FVA… set the seed for the random mode (from -1 to UINT32_MAX) (default -1)

aphaser AVOptions:
  in_gain ..F.A… set input gain (from 0 to 1) (default 0.4)
  out_gain ..F.A… set output gain (from 0 to 1e+009) (default 0.74)
  delay ..F.A… set delay in milliseconds (from 0 to 5) (default 3)
  decay ..F.A… set decay (from 0 to 0.99) (default 0.4)
  speed ..F.A… set modulation speed (from 0.1 to 2) (default 0.5)
  type ..F.A… set modulation type (from 0 to 1) (default 1)
     triangular ..F.A…
     t ..F.A…
     sinusoidal ..F.A…
     s ..F.A…

aresample AVOptions:
  sample_rate ..F.A… (from 0 to INT_MAX) (default 0)

SWResampler AVOptions:
  -ich ….A… set input channel count (from 0 to 32) (default 0)
  -in_channel_count ….A… set input channel count (from 0 to 32) (default 0)
  -och ….A… set output channel count (from 0 to 32) (default 0)
  -out_channel_count ….A… set output channel count (from 0 to 32) (default 0)
  -uch ….A… set used channel count (from 0 to 32) (default 0)
  -used_channel_count ….A… set used channel count (from 0 to 32) (default 0)
  -isr ….A… set input sample rate (from 0 to INT_MAX) (default 0)
  -in_sample_rate ….A… set input sample rate (from 0 to INT_MAX) (default 0)
  -osr ….A… set output sample rate (from 0 to INT_MAX) (default 0)
  -out_sample_rate ….A… set output sample rate (from 0 to INT_MAX) (default 0)
  -isf ….A… set input sample format (default none)
  -in_sample_fmt ….A… set input sample format (default none)
  -osf ….A… set output sample format (default none)
  -out_sample_fmt ….A… set output sample format (default none)
  -tsf ….A… set internal sample format (default none)
  -internal_sample_fmt ….A… set internal sample format (default none)
  -icl ….A… set input channel layout (default 0×0)
  -in_channel_layout ….A… set input channel layout (default 0×0)
  -ocl ….A… set output channel layout (default 0×0)
  -out_channel_layout ….A… set output channel layout (default 0×0)
  -clev ….A… set center mix level (from -32 to 32) (default 0.707107)
  -center_mix_level ….A… set center mix level (from -32 to 32) (default 0.707107)
  -slev ….A… set surround mix level (from -32 to 32) (default 0.707107)
  -surround_mix_level ….A… set surround mix Level (from -32 to 32) (default 0.707107)
  -lfe_mix_level ….A… set LFE mix level (from -32 to 32) (default 0)
  -rmvol ….A… set rematrix volume (from -1000 to 1000) (default 1)
  -rematrix_volume ….A… set rematrix volume (from -1000 to 1000) (default 1)
  -rematrix_maxval ….A… set rematrix maxval (from 0 to 1000) (default 0)
  -flags ….A… set flags (default 0)
     res ….A… force resampling
  -swr_flags ….A… set flags (default 0)
     res ….A… force resampling
  -dither_scale ….A… set dither scale (from 0 to INT_MAX) (default 1)
  -dither_method ….A… set dither method (from 0 to 71) (default 0)
     rectangular ….A… select rectangular dither
     triangular ….A… select triangular dither
     triangular_hp ….A… select triangular dither with high pass
     lipshitz ….A… select lipshitz noise shaping dither
     shibata ….A… select shibata noise shaping dither
     low_shibata ….A… select low shibata noise shaping dither
     high_shibata ….A… select high shibata noise shaping dither
     f_weighted ….A… select f-weighted noise shaping dither
     modified_e_weighted ….A… select modified-e-weighted noise shaping dither
     improved_e_weighted ….A… select improved-e-weighted noise shaping dither
  -filter_size ….A… set swr resampling filter size (from 0 to INT_MAX) (default 32)
  -phase_shift ….A… set swr resampling phase shift (from 0 to 24) (default 10)
  -linear_interp ….A… enable linear interpolation (from 0 to 1) (default 0)
  -cutoff ….A… set cutoff frequency ratio (from 0 to 1) (default 0)
  -resample_cutoff ….A… set cutoff frequency ratio (from 0 to 1) (default 0)
  -resampler ….A… set resampling Engine (from 0 to 1) (default 0)
     swr ….A… select SW Resampler
     soxr ….A… select SoX Resampler
  -precision ….A… set soxr resampling precision (in bits) (from 15 to 33) (default 20)
  -cheby ….A… enable soxr Chebyshev passband & higher-precision irrational ratio approximation (from 0 to 1) (default 0)
  -min_comp ….A… set minimum difference between timestamps and audio data (in seconds) below which no timestamp compensation of either kind is applied (from 0 to FLT_MAX) (default FLT_MAX)
  -min_hard_comp ….A… set minimum difference between timestamps and audio data (in seconds) to trigger padding/trimming the data. (from 0 to INT_MAX) (default 0.1)
  -comp_duration ….A… set duration (in seconds) over which data is stretched/squeezed to make it match the timestamps. (from 0 to INT_MAX) (default 1)
  -max_soft_comp ….A… set maximum factor by which data is stretched/squeezed to make it match the timestamps. (from INT_MIN to INT_MAX) (default 0)
  -async ….A… simplified 1 parameter audio timestamp matching, 0(disabled), 1(filling and trimming), >1(maximum stretch/squeeze in samples per second) (from INT_MIN to INT_MAX) (default 0)
  -first_pts ….A… Assume the first pts should be this value (in samples). (from I64_MIN to I64_MAX) (default I64_MIN)
  -matrix_encoding ….A… set matrixed stereo encoding (from 0 to 6) (default 0)
     none ….A… select none
     dolby ….A… select Dolby
     dplii ….A… select Dolby Pro Logic II
  -filter_type ….A… select swr filter type (from 0 to 2) (default 2)
     cubic ….A… select cubic
     blackman_nuttall ….A… select Blackman Nuttall Windowed Sinc
     kaiser ….A… select Kaiser Windowed Sinc
  -kaiser_beta ….A… set swr Kaiser Window Beta (from 2 to 16) (default 9)
  -output_sample_bits ….A… set swr number of output sample bits (from 0 to 64) (default 0)

aselect AVOptions:
  expr ..F.A… set an expression to use for selecting frames (default “1”)
  e ..F.A… set an expression to use for selecting frames (default “1”)
  outputs ..F.A… set the number of outputs (from 1 to INT_MAX) (default 1)
  n ..F.A… set the number of outputs (from 1 to INT_MAX) (default 1)

asendcmd AVOptions:
  commands ..FVA… set commands
  c ..FVA… set commands
  filename ..FVA… set commands file
  f ..FVA… set commands file

asetnsamples AVOptions:
  nb_out_samples ..F.A… set the number of per-frame output samples (from 1 to INT_MAX) (default 1024)
  n ..F.A… set the number of per-frame output samples (from 1 to INT_MAX) (default 1024)
  pad ..F.A… pad last frame with zeros (from 0 to 1) (default 1)
  p ..F.A… pad last frame with zeros (from 0 to 1) (default 1)

asetpts AVOptions:
  expr ..FVA… Expression determining the frame timestamp (default “PTS”)

asetrate AVOptions:
  sample_rate ..F.A… set the sample rate (from 1 to INT_MAX) (default 44100)
  r ..F.A… set the sample rate (from 1 to INT_MAX) (default 44100)

asettb AVOptions:
  expr ..F.A… set expression determining the output timebase (default “intb”)
  tb ..F.A… set expression determining the output timebase (default “intb”)

asplit AVOptions:
  -outputs …VA… set number of outputs (from 1 to INT_MAX) (default 2)

astats AVOptions:
  length ..F.A… set the window length (from 0.01 to 10) (default 0.05)

astreamsync AVOptions:
  expr ..F.A… set stream selection expression (default “t1-t2”)
  e ..F.A… set stream selection expression (default “t1-t2”)

atempo AVOptions:
  tempo ..F.A… set tempo scale factor (from 0.5 to 2) (default 1)

atrim AVOptions:
  starti ..F.A… Timestamp of the first frame that should be passed (default I64_MAX)
  endi ..F.A… Timestamp of the first frame that should be dropped again (default I64_MAX)
  start_pts ..F.A… Timestamp of the first frame that should be passed (from I64_MIN to I64_MAX) (default I64_MIN)
  end_pts ..F.A… Timestamp of the first frame that should be dropped again (from I64_MIN to I64_MAX) (default I64_MIN)
  durationi ..F.A… Maximum duration of the output (default 0)
  start_sample ..F.A… Number of the first audio sample that should be passed to the output (from -1 to I64_MAX) (default -1)
  end_sample ..F.A… Number of the first audio sample that should be dropped again (from 0 to I64_MAX) (default I64_MAX)
  start ..F.A… Timestamp in seconds of the first frame that should be passed (from -DBL_MAX to DBL_MAX) (default DBL_MAX)
  end ..F.A… Timestamp in seconds of the first frame that should be dropped again (from -DBL_MAX to DBL_MAX) (default DBL_MAX)
  duration ..F.A… Maximum duration of the output in seconds (from 0 to DBL_MAX) (default 0)

bandpass AVOptions:
  frequency ..F.A… set central frequency (from 0 to 999999) (default 3000)
  f ..F.A… set central frequency (from 0 to 999999) (default 3000)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 3)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set band-width (from 0 to 999) (default 0.5)
  w ..F.A… set band-width (from 0 to 999) (default 0.5)
  csg ..F.A… use constant skirt gain (from 0 to 1) (default 0)

bandreject AVOptions:
  frequency ..F.A… set central frequency (from 0 to 999999) (default 3000)
  f ..F.A… set central frequency (from 0 to 999999) (default 3000)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 3)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set band-width (from 0 to 999) (default 0.5)
  w ..F.A… set band-width (from 0 to 999) (default 0.5)

bass AVOptions:
  frequency ..F.A… set central frequency (from 0 to 999999) (default 100)
  f ..F.A… set central frequency (from 0 to 999999) (default 100)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 3)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set shelf transition steep (from 0 to 99999) (default 0.5)
  w ..F.A… set shelf transition steep (from 0 to 99999) (default 0.5)
  gain ..F.A… set gain (from -900 to 900) (default 0)
  g ..F.A… set gain (from -900 to 900) (default 0)

biquad AVOptions:
  a0 ..F.A… (from -32768 to 32767) (default 1)
  a1 ..F.A… (from -32768 to 32767) (default 1)
  a2 ..F.A… (from -32768 to 32767) (default 1)
  b0 ..F.A… (from -32768 to 32767) (default 1)
  b1 ..F.A… (from -32768 to 32767) (default 1)
  b2 ..F.A… (from -32768 to 32767) (default 1)

channelmap AVOptions:
  map ..F.A… A comma-separated list of input channel numbers in output order.
  channel_layout ..F.A… Output channel layout.

channelsplit AVOptions:
  channel_layout ..F.A… Input channel layout. (default “stereo”)

compand AVOptions:
  attacks ..F.A… set time over which increase of volume is determined (default “0.3”)
  decays ..F.A… set time over which decrease of volume is determined (default “0.8”)
  points ..F.A… set points of transfer function (default “-70/-70|-60/-20”)
  soft-knee ..F.A… set soft-knee (from 0.01 to 900) (default 0.01)
  gain ..F.A… set output gain (from -900 to 900) (default 0)
  volume ..F.A… set initial volume (from -900 to 0) (default 0)
  delay ..F.A… set delay for samples before sending them to volume adjuster (from 0 to 20) (default 0)

ebur128 AVOptions:
  video ..FV…. set video output (from 0 to 1) (default 0)
  size ..FV…. set video size (default “640×480”)
  meter ..FV…. set scale meter (+9 to +18) (from 9 to 18) (default 9)
  framelog ..FVA… force frame logging level (from INT_MIN to INT_MAX) (default -1)
     info ..FVA… information logging level
     verbose ..FVA… verbose logging level
  metadata ..FVA… inject metadata in the filtergraph (from 0 to 1) (default 0)
  peak ..F.A… set peak mode (default 0)
     none ..F.A… disable any peak mode
     sample ..F.A… enable peak-sample mode
     true ..F.A… enable true-peak mode

equalizer AVOptions:
  frequency ..F.A… set central frequency (from 0 to 999999) (default 0)
  f ..F.A… set central frequency (from 0 to 999999) (default 0)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 3)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set band-width (from 0 to 999) (default 1)
  w ..F.A… set band-width (from 0 to 999) (default 1)
  gain ..F.A… set gain (from -900 to 900) (default 0)
  g ..F.A… set gain (from -900 to 900) (default 0)

highpass AVOptions:
  frequency ..F.A… set frequency (from 0 to 999999) (default 3000)
  f ..F.A… set frequency (from 0 to 999999) (default 3000)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 3)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set width (from 0 to 99999) (default 0.707)
  w ..F.A… set width (from 0 to 99999) (default 0.707)
  poles ..F.A… set number of poles (from 1 to 2) (default 2)
  p ..F.A… set number of poles (from 1 to 2) (default 2)

join AVOptions:
  inputs ..F.A… Number of input streams. (from 1 to INT_MAX) (default 2)
  channel_layout ..F.A… Channel layout of the output stream. (default “stereo”)
  map ..F.A… A comma-separated list of channels maps in the format ‘input_stream.input_channel-output_channel.

lowpass AVOptions:
  frequency ..F.A… set frequency (from 0 to 999999) (default 500)
  f ..F.A… set frequency (from 0 to 999999) (default 500)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 3)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set width (from 0 to 99999) (default 0.707)
  w ..F.A… set width (from 0 to 99999) (default 0.707)
  poles ..F.A… set number of poles (from 1 to 2) (default 2)
  p ..F.A… set number of poles (from 1 to 2) (default 2)

pan AVOptions:
  args ..F.A…

silencedetect AVOptions:
  n ..F.A… set noise tolerance (from 0 to DBL_MAX) (default 0.001)
  noise ..F.A… set noise tolerance (from 0 to DBL_MAX) (default 0.001)
  d ..F.A… set minimum duration in seconds (from 0 to 86400) (default 2)
  duration ..F.A… set minimum duration in seconds (from 0 to 86400) (default 2)

treble AVOptions:
  frequency ..F.A… set central frequency (from 0 to 999999) (default 3000)
  f ..F.A… set central frequency (from 0 to 999999) (default 3000)
  width_type ..F.A… set filter-width type (from 1 to 4) (default 3)
     h ..F.A… Hz
     q ..F.A… Q-Factor
     o ..F.A… octave
     s ..F.A… slope
  width ..F.A… set shelf transition steep (from 0 to 99999) (default 0.5)
  w ..F.A… set shelf transition steep (from 0 to 99999) (default 0.5)
  gain ..F.A… set gain (from -900 to 900) (default 0)
  g ..F.A… set gain (from -900 to 900) (default 0)

volume AVOptions:
  volume ..F.A… set volume adjustment expression (default “1.0”)
  precision ..F.A… select mathematical precision (from 0 to 2) (default 1)
     fixed ..F.A… select 8-bit fixed-point
     float ..F.A… select 32-bit floating-point
     double ..F.A… select 64-bit floating-point
  eval ..F.A… specify when to evaluate expressions (from 0 to 1) (default 0)
     once ..F.A… eval volume expression once
     frame ..F.A… eval volume expression per-frame
  -replaygain ….A… Apply replaygain side data when present (from 0 to 3) (default 0)
     drop ….A… replaygain side data is dropped
     ignore ….A… replaygain side data is ignored
     track ….A… track gain is preferred
     album ….A… album gain is preferred
  -replaygain_preamp ….A… Apply replaygain pre-amplification (from -15 to 15) (default 0)
  -replaygain_noclip ….A… Apply replaygain clipping prevention (from 0 to 1) (default 1)

aevalsrc AVOptions:
  exprs ..F.A… set the ‘|’-separated list of channels expressions
  nb_samples ..F.A… set the number of samples per requested frame (from 0 to INT_MAX) (default 1024)
  n ..F.A… set the number of samples per requested frame (from 0 to INT_MAX) (default 1024)
  sample_rate ..F.A… set the sample rate (default “44100”)
  s ..F.A… set the sample rate (default “44100”)
  duration ..F.A… set audio duration (default -1)
  d ..F.A… set audio duration (default -1)
  channel_layout ..F.A… set channel layout
  c ..F.A… set channel layout

anullsrc AVOptions:
  channel_layout ..F.A… set channel_layout (default “stereo”)
  cl ..F.A… set channel_layout (default “stereo”)
  sample_rate ..F.A… set sample rate (default “44100”)
  r ..F.A… set sample rate (default “44100”)
  nb_samples ..F.A… set the number of samples per requested frame (from 0 to INT_MAX) (default 1024)
  n ..F.A… set the number of samples per requested frame (from 0 to INT_MAX) (default 1024)

sine AVOptions:
  frequency ..F.A… set the sine frequency (from 0 to DBL_MAX) (default 440)
  f ..F.A… set the sine frequency (from 0 to DBL_MAX) (default 440)
  beep_factor ..F.A… set the beep fequency factor (from 0 to DBL_MAX) (default 0)
  b ..F.A… set the beep fequency factor (from 0 to DBL_MAX) (default 0)
  sample_rate ..F.A… set the sample rate (from 1 to INT_MAX) (default 44100)
  r ..F.A… set the sample rate (from 1 to INT_MAX) (default 44100)
  duration ..F.A… set the audio duration (default 0)
  d ..F.A… set the audio duration (default 0)
  samples_per_frame ..F.A… set the number of samples per frame (from 0 to INT_MAX) (default 1024)

ass AVOptions:
  filename ..FV…. set the filename of file to read
  f ..FV…. set the filename of file to read
  original_size ..FV…. set the size of the original video (used to scale fonts)

bbox AVOptions:
  min_val ..FV…. set minimum luminance value for bounding box (from 0 to 254) (default 16)

blackdetect AVOptions:
  d ..FV…. set minimum detected black duration in seconds (from 0 to DBL_MAX) (default 2)
  black_min_duration ..FV…. set minimum detected black duration in seconds (from 0 to DBL_MAX) (default 2)
  picture_black_ratio_th ..FV…. set the picture black ratio threshold (from 0 to 1) (default 0.98)
  pic_th ..FV…. set the picture black ratio threshold (from 0 to 1) (default 0.98)
  pixel_black_th ..FV…. set the pixel black threshold (from 0 to 1) (default 0.1)
  pix_th ..FV…. set the pixel black threshold (from 0 to 1) (default 0.1)

blackframe AVOptions:
  amount ..FV…. Percentage of the pixels that have to be below the threshold for the frame to be considered black. (from 0 to 100) (default 98)
  threshold ..FV…. threshold below which a pixel value is considered black (from 0 to 255) (default 32)
  thresh ..FV…. threshold below which a pixel value is considered black (from 0 to 255) (default 32)

blend AVOptions:
  c0_mode ..FV…. set component #0 blend mode (from 0 to 23) (default 0)
     addition ..FV…. 
     and ..FV…. 
     average ..FV…. 
     burn ..FV…. 
     darken ..FV…. 
     difference ..FV…. 
     divide ..FV…. 
     dodge ..FV…. 
     exclusion ..FV…. 
     hardlight ..FV…. 
     lighten ..FV…. 
     multiply ..FV…. 
     negation ..FV…. 
     normal ..FV…. 
     or ..FV…. 
     overlay ..FV…. 
     phoenix ..FV…. 
     pinlight ..FV…. 
     reflect ..FV…. 
     screen ..FV…. 
     softlight ..FV…. 
     subtract ..FV…. 
     vividlight ..FV…. 
     xor ..FV…. 
  c1_mode ..FV…. set component #1 blend mode (from 0 to 23) (default 0)
     addition ..FV…. 
     and ..FV…. 
     average ..FV…. 
     burn ..FV…. 
     darken ..FV…. 
     difference ..FV…. 
     divide ..FV…. 
     dodge ..FV…. 
     exclusion ..FV…. 
     hardlight ..FV…. 
     lighten ..FV…. 
     multiply ..FV…. 
     negation ..FV…. 
     normal ..FV…. 
     or ..FV…. 
     overlay ..FV…. 
     phoenix ..FV…. 
     pinlight ..FV…. 
     reflect ..FV…. 
     screen ..FV…. 
     softlight ..FV…. 
     subtract ..FV…. 
     vividlight ..FV…. 
     xor ..FV…. 
  c2_mode ..FV…. set component #2 blend mode (from 0 to 23) (default 0)
     addition ..FV…. 
     and ..FV…. 
     average ..FV…. 
     burn ..FV…. 
     darken ..FV…. 
     difference ..FV…. 
     divide ..FV…. 
     dodge ..FV…. 
     exclusion ..FV…. 
     hardlight ..FV…. 
     lighten ..FV…. 
     multiply ..FV…. 
     negation ..FV…. 
     normal ..FV…. 
     or ..FV…. 
     overlay ..FV…. 
     phoenix ..FV…. 
     pinlight ..FV…. 
     reflect ..FV…. 
     screen ..FV…. 
     softlight ..FV…. 
     subtract ..FV…. 
     vividlight ..FV…. 
     xor ..FV…. 
  c3_mode ..FV…. set component #3 blend mode (from 0 to 23) (default 0)
     addition ..FV…. 
     and ..FV…. 
     average ..FV…. 
     burn ..FV…. 
     darken ..FV…. 
     difference ..FV…. 
     divide ..FV…. 
     dodge ..FV…. 
     exclusion ..FV…. 
     hardlight ..FV…. 
     lighten ..FV…. 
     multiply ..FV…. 
     negation ..FV…. 
     normal ..FV…. 
     or ..FV…. 
     overlay ..FV…. 
     phoenix ..FV…. 
     pinlight ..FV…. 
     reflect ..FV…. 
     screen ..FV…. 
     softlight ..FV…. 
     subtract ..FV…. 
     vividlight ..FV…. 
     xor ..FV…. 
  all_mode ..FV…. set blend mode for all components (from -1 to 23) (default -1)
     addition ..FV…. 
     and ..FV…. 
     average ..FV…. 
     burn ..FV…. 
     darken ..FV…. 
     difference ..FV…. 
     divide ..FV…. 
     dodge ..FV…. 
     exclusion ..FV…. 
     hardlight ..FV…. 
     lighten ..FV…. 
     multiply ..FV…. 
     negation ..FV…. 
     normal ..FV…. 
     or ..FV…. 
     overlay ..FV…. 
     phoenix ..FV…. 
     pinlight ..FV…. 
     reflect ..FV…. 
     screen ..FV…. 
     softlight ..FV…. 
     subtract ..FV…. 
     vividlight ..FV…. 
     xor ..FV…. 
  c0_expr ..FV…. set color component #0 expression
  c1_expr ..FV…. set color component #1 expression
  c2_expr ..FV…. set color component #2 expression
  c3_expr ..FV…. set color component #3 expression
  all_expr ..FV…. set expression for all color components
  c0_opacity ..FV…. set color component #0 opacity (from 0 to 1) (default 1)
  c1_opacity ..FV…. set color component #1 opacity (from 0 to 1) (default 1)
  c2_opacity ..FV…. set color component #2 opacity (from 0 to 1) (default 1)
  c3_opacity ..FV…. set color component #3 opacity (from 0 to 1) (default 1)
  all_opacity ..FV…. set opacity for all color components (from 0 to 1) (default 1)
  shortest ..FV…. force termination when the shortest input terminates (from 0 to 1) (default 0)
  repeatlast ..FV…. repeat last bottom frame (from 0 to 1) (default 1)

boxblur AVOptions:
  luma_radius ..FV…. Radius of the luma blurring box (default “2”)
  lr ..FV…. Radius of the luma blurring box (default “2”)
  luma_power ..FV…. How many times should the boxblur be applied to luma (from 0 to INT_MAX) (default 2)
  lp ..FV…. How many times should the boxblur be applied to luma (from 0 to INT_MAX) (default 2)
  chroma_radius ..FV…. Radius of the chroma blurring box
  cr ..FV…. Radius of the chroma blurring box
  chroma_power ..FV…. How many times should the boxblur be applied to chroma (from -1 to INT_MAX) (default -1)
  cp ..FV…. How many times should the boxblur be applied to chroma (from -1 to INT_MAX) (default -1)
  alpha_radius ..FV…. Radius of the alpha blurring box
  ar ..FV…. Radius of the alpha blurring box
  alpha_power ..FV…. How many times should the boxblur be applied to alpha (from -1 to INT_MAX) (default -1)
  ap ..FV…. How many times should the boxblur be applied to alpha (from -1 to INT_MAX) (default -1)

colorbalance AVOptions:
  rs ..FV…. set red shadows (from -1 to 1) (default 0)
  gs ..FV…. set green shadows (from -1 to 1) (default 0)
  bs ..FV…. set blue shadows (from -1 to 1) (default 0)
  rm ..FV…. set red midtones (from -1 to 1) (default 0)
  gm ..FV…. set green midtones (from -1 to 1) (default 0)
  bm ..FV…. set blue midtones (from -1 to 1) (default 0)
  rh ..FV…. set red highlights (from -1 to 1) (default 0)
  gh ..FV…. set green highlights (from -1 to 1) (default 0)
  bh ..FV…. set blue highlights (from -1 to 1) (default 0)

colorchannelmixer AVOptions:
  rr ..FV…. set the red gain for the red channel (from -2 to 2) (default 1)
  rg ..FV…. set the green gain for the red channel (from -2 to 2) (default 0)
  rb ..FV…. set the blue gain for the red channel (from -2 to 2) (default 0)
  ra ..FV…. set the alpha gain for the red channel (from -2 to 2) (default 0)
  gr ..FV…. set the red gain for the green channel (from -2 to 2) (default 0)
  gg ..FV…. set the green gain for the green channel (from -2 to 2) (default 1)
  gb ..FV…. set the blue gain for the green channel (from -2 to 2) (default 0)
  ga ..FV…. set the alpha gain for the green channel (from -2 to 2) (default 0)
  br ..FV…. set the red gain for the blue channel (from -2 to 2) (default 0)
  bg ..FV…. set the green gain for the blue channel (from -2 to 2) (default 0)
  bb ..FV…. set the blue gain for the blue channel (from -2 to 2) (default 1)
  ba ..FV…. set the alpha gain for the blue channel (from -2 to 2) (default 0)
  ar ..FV…. set the red gain for the alpha channel (from -2 to 2) (default 0)
  ag ..FV…. set the green gain for the alpha channel (from -2 to 2) (default 0)
  ab ..FV…. set the blue gain for the alpha channel (from -2 to 2) (default 0)
  aa ..FV…. set the alpha gain for the alpha channel (from -2 to 2) (default 1)

colormatrix AVOptions:
  src ..FV…. set source color matrix (from -1 to 3) (default -1)
     bt709 ..FV…. set BT.709 colorspace
     fcc ..FV…. set FCC colorspace 
     bt601 ..FV…. set BT.601 colorspace
     smpte240m ..FV…. set SMPTE-240M colorspace
  dst ..FV…. set destination color matrix (from -1 to 3) (default -1)
     bt709 ..FV…. set BT.709 colorspace
     fcc ..FV…. set FCC colorspace 
     bt601 ..FV…. set BT.601 colorspace
     smpte240m ..FV…. set SMPTE-240M colorspace

crop AVOptions:
  out_w ..FV…. set the width crop area expression (default “iw”)
  w ..FV…. set the width crop area expression (default “iw”)
  out_h ..FV…. set the height crop area expression (default “ih”)
  h ..FV…. set the height crop area expression (default “ih”)
  x ..FV…. set the x crop area expression (default “(in_w-out_w)/2”)
  y ..FV…. set the y crop area expression (default “(in_h-out_h)/2”)
  keep_aspect ..FV…. keep aspect ratio (from 0 to 1) (default 0)

cropdetect AVOptions:
  limit ..FV…. Threshold below which the pixel is considered black (from 0 to 255) (default 24)
  round ..FV…. Value by which the width/height should be divisible (from 0 to INT_MAX) (default 16)
  reset ..FV…. Recalculate the crop area after this many frames (from 0 to INT_MAX) (default 0)
  reset_count ..FV…. Recalculate the crop area after this many frames (from 0 to INT_MAX) (default 0)

curves AVOptions:
  preset ..FV…. select a color curves preset (from 0 to 10) (default 0)
     none ..FV….
     color_negative ..FV….
     cross_process ..FV….
     darker ..FV….
     increase_contrast ..FV….
     lighter ..FV….
     linear_contrast ..FV….
     medium_contrast ..FV….
     negative ..FV….
     strong_contrast ..FV….
     vintage ..FV….
  master ..FV…. set master points coordinates
  m ..FV…. set master points coordinates
  red ..FV…. set red points coordinates
  r ..FV…. set red points coordinates
  green ..FV…. set green points coordinates
  g ..FV…. set green points coordinates
  blue ..FV…. set blue points coordinates
  b ..FV…. set blue points coordinates
  all ..FV…. set points coordinates for all components
  psfile ..FV…. set Photoshop curves file name

dctdnoiz AVOptions:
  sigma ..FV…. set noise sigma constant (from 0 to 999) (default 0)
  s ..FV…. set noise sigma constant (from 0 to 999) (default 0)
  overlap ..FV…. set number of block overlapping pixels (from 0 to 15) (default 15)
  expr ..FV…. set coefficient factor expression
  e ..FV…. set coefficient factor expression

decimate AVOptions:
  cycle ..FV…. set the number of frame from which one will be dropped (from 2 to 25) (default 5)
  dupthresh ..FV…. set duplicate threshold (from 0 to 100) (default 1.1)
  scthresh ..FV…. set scene change threshold (from 0 to 100) (default 15)
  blockx ..FV…. set the size of the x-axis blocks used during metric calculations (from 4 to 512) (default 32)
  blocky ..FV…. set the size of the y-axis blocks used during metric calculations (from 4 to 512) (default 32)
  ppsrc ..FV…. mark main input as a pre-processed input and activate clean source input stream (from 0 to 1) (default 0)
  chroma ..FV…. set whether or not chroma is considered in the metric calculations (from 0 to 1) (default 1)

dejudder AVOptions:
  cycle ..FV…. set the length of the cycle to use for dejuddering (from 2 to 240) (default 4)

delogo AVOptions:
  x ..FV…. set logo x position (from -1 to INT_MAX) (default -1)
  y ..FV…. set logo y position (from -1 to INT_MAX) (default -1)
  w ..FV…. set logo width (from -1 to INT_MAX) (default -1)
  h ..FV…. set logo height (from -1 to INT_MAX) (default -1)
  band ..FV…. set delogo area band size (from 1 to INT_MAX) (default 4)
  t ..FV…. set delogo area band size (from 1 to INT_MAX) (default 4)
  show ..FV…. show delogo area (from 0 to 1) (default 0)

deshake AVOptions:
  x ..FV…. set x for the rectangular search area (from -1 to INT_MAX) (default -1)
  y ..FV…. set y for the rectangular search area (from -1 to INT_MAX) (default -1)
  w ..FV…. set width for the rectangular search area (from -1 to INT_MAX) (default -1)
  h ..FV…. set height for the rectangular search area (from -1 to INT_MAX) (default -1)
  rx ..FV…. set x for the rectangular search area (from 0 to 64) (default 16)
  ry ..FV…. set y for the rectangular search area (from 0 to 64) (default 16)
  edge ..FV…. set edge mode (from 0 to 3) (default 3)
     blank ..FV…. fill zeroes at blank locations
     original ..FV…. original image at blank locations
     clamp ..FV…. extruded edge value at blank locations
     mirror ..FV…. mirrored edge at blank locations
  blocksize ..FV…. set motion search blocksize (from 4 to 128) (default 8)
  contrast ..FV…. set contrast threshold for blocks (from 1 to 255) (default 125)
  search ..FV…. set search strategy (from 0 to 1) (default 0)
     exhaustive ..FV…. exhaustive search
     less ..FV…. less exhaustive search
  filename ..FV…. set motion search detailed log file name
  opencl ..FV…. use OpenCL filtering capabilities (from 0 to 1) (default 0)

drawbox AVOptions:
  x ..FV…. set horizontal position of the left box edge (default “0”)
  y ..FV…. set vertical position of the top box edge (default “0”)
  width ..FV…. set width of the box (default “0”)
  w ..FV…. set width of the box (default “0”)
  height ..FV…. set height of the box (default “0”)
  h ..FV…. set height of the box (default “0”)
  color ..FV…. set color of the box (default “black”)
  c ..FV…. set color of the box (default “black”)
  thickness ..FV…. set the box thickness (default “3”)
  t ..FV…. set the box thickness (default “3”)

drawgrid AVOptions:
  x ..FV…. set horizontal offset (default “0”)
  y ..FV…. set vertical offset (default “0”)
  width ..FV…. set width of grid cell (default “0”)
  w ..FV…. set width of grid cell (default “0”)
  height ..FV…. set height of grid cell (default “0”)
  h ..FV…. set height of grid cell (default “0”)
  color ..FV…. set color of the grid (default “black”)
  c ..FV…. set color of the grid (default “black”)
  thickness ..FV…. set grid line thickness (default “1”)
  t ..FV…. set grid line thickness (default “1”)

drawtext AVOptions:
  fontfile ..FV…. set font file
  text ..FV…. set text
  textfile ..FV…. set text file
  fontcolor ..FV…. set foreground color (default “black”)
  boxcolor ..FV…. set box color (default “white”)
  bordercolor ..FV…. set border color (default “black”)
  shadowcolor ..FV…. set shadow color (default “black”)
  box ..FV…. set box (from 0 to 1) (default 0)
  fontsize ..FV…. set font size (from 0 to INT_MAX) (default 0)
  x ..FV…. set x expression (default “0”)
  y ..FV…. set y expression (default “0”)
  shadowx ..FV…. set x (from INT_MIN to INT_MAX) (default 0)
  shadowy ..FV…. set y (from INT_MIN to INT_MAX) (default 0)
  borderw ..FV…. set border width (from INT_MIN to INT_MAX) (default 0)
  tabsize ..FV…. set tab size (from 0 to INT_MAX) (default 4)
  basetime ..FV…. set base time (from I64_MIN to I64_MAX) (default I64_MIN)
  draw ..FV…. if false do not draw (deprecated)
  expansion ..FV…. set the expansion mode (from 0 to 2) (default 1)
     none ..FV…. set no expansion
     normal ..FV…. set normal expansion
     strftime ..FV…. set strftime expansion (deprecated)
  timecode ..FV…. set initial timecode
  tc24hmax ..FV…. set 24 hours max (timecode only) (from 0 to 1) (default 0)
  timecode_rate ..FV…. set rate (timecode only) (from 0 to INT_MAX) (default 0/1)
  r ..FV…. set rate (timecode only) (from 0 to INT_MAX) (default 0/1)
  rate ..FV…. set rate (timecode only) (from 0 to INT_MAX) (default 0/1)
  reload ..FV…. reload text file for each frame (from 0 to 1) (default 0)
  fix_bounds ..FV…. if true, check and fix text coords to avoid clipping (from 0 to 1) (default 1)
  start_number ..FV…. start frame number for n/frame_num variable (from 0 to INT_MAX) (default 0)
  ft_load_flags ..FV…. set font loading flags for libfreetype (default 0)
     default ..FV….
     no_scale ..FV….
     no_hinting ..FV….
     render ..FV….
     no_bitmap ..FV….
     vertical_layout ..FV….
     force_autohint ..FV….
     crop_bitmap ..FV….
     pedantic ..FV….
     ignore_global_advance_width ..FV….
     no_recurse ..FV….
     ignore_transform ..FV….
     monochrome ..FV….
     linear_design ..FV….
     no_autohint ..FV….

edgedetect AVOptions:
  high ..FV…. set high threshold (from 0 to 1) (default 0.196078)
  low ..FV…. set low threshold (from 0 to 1) (default 0.0784314)

elbg AVOptions:
  codebook_length ..FV…. set codebook length (from 1 to INT_MAX) (default 256)
  l ..FV…. set codebook length (from 1 to INT_MAX) (default 256)
  nb_steps ..FV…. set max number of steps used to compute the mapping (from 1 to INT_MAX) (default 1)
  n ..FV…. set max number of steps used to compute the mapping (from 1 to INT_MAX) (default 1)
  seed ..FV…. set the random seed (from -1 to UINT32_MAX) (default -1)
  s ..FV…. set the random seed (from -1 to UINT32_MAX) (default -1)

extractplanes AVOptions:
  planes ..FV…. set planes (default 1)
     y ..FV…. set luma plane
     u ..FV…. set u plane
     v ..FV…. set v plane
     r ..FV…. set red plane
     g ..FV…. set green plane
     b ..FV…. set blue plane
     a ..FV…. set alpha plane

fade AVOptions:
  type ..FV…. ‘in’ or ‘out’ for fade-in/fade-out (from 0 to 1) (default 0)
  t ..FV…. ‘in’ or ‘out’ for fade-in/fade-out (from 0 to 1) (default 0)
  start_frame ..FV…. Number of the first frame to which to apply the effect. (from 0 to INT_MAX) (default 0)
  s ..FV…. Number of the first frame to which to apply the effect. (from 0 to INT_MAX) (default 0)
  nb_frames ..FV…. Number of frames to which the effect should be applied. (from 0 to INT_MAX) (default 25)
  n ..FV…. Number of frames to which the effect should be applied. (from 0 to INT_MAX) (default 25)
  alpha ..FV…. fade alpha if it is available on the input (from 0 to 1) (default 0)
  start_time ..FV…. Number of seconds of the beginning of the effect. (default 0)
  st ..FV…. Number of seconds of the beginning of the effect. (default 0)
  duration ..FV…. Duration of the effect in seconds. (default 0)
  d ..FV…. Duration of the effect in seconds. (default 0)
  color ..FV…. set color (default “black”)
  c ..FV…. set color (default “black”)

field AVOptions:
  type ..FV…. set field type (top or bottom) (from 0 to 1) (default 0)
     top ..FV…. select top field
     bottom ..FV…. select bottom field

fieldmatch AVOptions:
  order ..FV…. specify the assumed field order (from -1 to 1) (default -1)
     auto ..FV…. auto detect parity
     bff ..FV…. assume bottom field first
     tff ..FV…. assume top field first
  mode ..FV…. set the matching mode or strategy to use (from 0 to 5) (default 1)
     pc ..FV…. 2-way match (p/c)
     pc_n ..FV…. 2-way match + 3rd match on combed (p/c + u)
     pc_u ..FV…. 2-way match + 3rd match (same order) on combed (p/c + u)
     pc_n_ub ..FV…. 2-way match + 3rd match on combed + 4th/5th matches if still combed (p/c + u + u/b)
     pcn ..FV…. 3-way match (p/c/n)
     pcn_ub ..FV…. 3-way match + 4th/5th matches on combed (p/c/n + u/b)
  ppsrc ..FV…. mark main input as a pre-processed input and activate clean source input stream (from 0 to 1) (default 0)
  field ..FV…. set the field to match from (from -1 to 1) (default -1)
     auto ..FV…. automatic (same value as ‘order’)
     bottom ..FV…. bottom field
     top ..FV…. top field
  mchroma ..FV…. set whether or not chroma is included during the match comparisons (from 0 to 1) (default 1)
  y0 ..FV…. define an exclusion band which excludes the lines between y0 and y1 from the field matching decision (from 0 to INT_MAX) (default 0)
  y1 ..FV…. define an exclusion band which excludes the lines between y0 and y1 from the field matching decision (from 0 to INT_MAX) (default 0)
  scthresh ..FV…. set scene change detection threshold (from 0 to 100) (default 12)
  combmatch ..FV…. set combmatching mode (from 0 to 2) (default 1)
     none ..FV…. disable combmatching
     sc ..FV…. enable combmatching only on scene change
     full ..FV…. enable combmatching all the time
  combdbg ..FV…. enable comb debug (from 0 to 2) (default 0)
     none ..FV…. no forced calculation
     pcn ..FV…. calculate p/c/n
     pcnub ..FV…. calculate p/c/n/u/b
  cthresh ..FV…. set the area combing threshold used for combed frame detection (from -1 to 255) (default 9)
  chroma ..FV…. set whether or not chroma is considered in the combed frame decision (from 0 to 1) (default 0)
  blockx ..FV…. set the x-axis size of the window used during combed frame detection (from 4 to 512) (default 16)
  blocky ..FV…. set the y-axis size of the window used during combed frame detection (from 4 to 512) (default 16)
  combpel ..FV…. set the number of combed pixels inside any of the blocky by blockx size blocks on the frame for the frame to be detected as combed (from 0 to INT_MAX) (default 80)

fieldorder AVOptions:
  order ..FV…. output field order (from 0 to 1) (default 1)
     bff ..FV…. bottom field first
     tff ..FV…. top field first

format AVOptions:
  -pix_fmts …V…. A ‘|’-separated list of pixel formats

fps AVOptions:
  fps ..FV…. A string describing desired output framerate (default “25”)
  -start_time …V…. Assume the first PTS should be this value. (from -DBL_MAX to DBL_MAX) (default DBL_MAX)
  round ..FV…. set rounding method for timestamps (from 0 to 5) (default 5)
     zero ..FV…. round towards 0
     inf ..FV…. round away from 0
     down ..FV…. round towards -infty
     up ..FV…. round towards +infty
     near ..FV…. round to nearest

framepack AVOptions:
  -format …V…. Frame pack output format (from 0 to INT_MAX) (default 1)
     sbs …V…. Views are packed next to each other
     tab …V…. Views are packed on top of each other
     frameseq …V…. Views are one after the other
     lines …V…. Views are interleaved by lines
     columns …V…. Views are interleaved by columns

framestep AVOptions:
  step ..FV…. set frame step (from 1 to INT_MAX) (default 1)

frei0r AVOptions:
  filter_name ..FV….
  filter_params ..FV….

geq AVOptions:
  lum_expr ..FV…. set luminance expression
  lum ..FV…. set luminance expression
  cb_expr ..FV…. set chroma blue expression
  cb ..FV…. set chroma blue expression
  cr_expr ..FV…. set chroma red expression
  cr ..FV…. set chroma red expression
  alpha_expr ..FV…. set alpha expression
  a ..FV…. set alpha expression
  red_expr ..FV…. set red expression
  r ..FV…. set red expression
  green_expr ..FV…. set green expression
  g ..FV…. set green expression
  blue_expr ..FV…. set blue expression
  b ..FV…. set blue expression

gradfun AVOptions:
  strength ..FV…. The maximum amount by which the filter will change any one pixel. (from 0.51 to 64) (default 1.2)
  radius ..FV…. The neighborhood to fit the gradient to. (from 4 to 32) (default 16)

haldclut AVOptions:
  shortest ..FV…. force termination when the shortest input terminates (from 0 to 1) (default 0)
  repeatlast ..FV…. continue applying the last clut after eos (from 0 to 1) (default 1)
  interp ..FV…. select interpolation mode (from 0 to 2) (default 2)
     nearest ..FV…. use values from the nearest defined points
     trilinear ..FV…. interpolate values using the 8 points defining a cube
     tetrahedral ..FV…. interpolate values using a tetrahedron

histeq AVOptions:
  strength ..FV…. set the strength (from 0 to 1) (default 0.2)
  intensity ..FV…. set the intensity (from 0 to 1) (default 0.21)
  antibanding ..FV…. set the antibanding level (from 0 to 2) (default 0)
     none ..FV…. apply no antibanding
     weak ..FV…. apply weak antibanding
     strong ..FV…. apply strong antibanding

histogram AVOptions:
  mode ..FV…. set histogram mode (from 0 to 3) (default 0)
     levels ..FV…. standard histogram
     waveform ..FV…. per row/column luminance graph
     color ..FV…. chroma values in vectorscope
     color2 ..FV…. chroma values in vectorscope
  level_height ..FV…. set level height (from 50 to 2048) (default 200)
  scale_height ..FV…. set scale height (from 0 to 40) (default 12)
  step ..FV…. set waveform step value (from 1 to 255) (default 10)
  waveform_mode ..FV…. set waveform mode (from 0 to 1) (default 0)
     row ..FV….
     column ..FV….
  waveform_mirror ..FV…. set waveform mirroring (from 0 to 1) (default 0)
  display_mode ..FV…. set display mode (from 0 to 1) (default 1)
     parade ..FV….
     overlay ..FV….
  levels_mode ..FV…. set levels mode (from 0 to 1) (default 0)
     linear ..FV….
     logarithmic ..FV….

hqdn3d AVOptions:
  luma_spatial ..FV…. spatial luma strength (from 0 to DBL_MAX) (default 0)
  chroma_spatial ..FV…. spatial chroma strength (from 0 to DBL_MAX) (default 0)
  luma_tmp ..FV…. temporal luma strength (from 0 to DBL_MAX) (default 0)
  chroma_tmp ..FV…. temporal chroma strength (from 0 to DBL_MAX) (default 0)

hue AVOptions:
  h ..FV…. set the hue angle degrees expression
  s ..FV…. set the saturation expression (default “1”)
  H ..FV…. set the hue angle radians expression
  b ..FV…. set the brightness expression (default “0”)

idet AVOptions:
  intl_thres ..FV…. set interlacing threshold (from -1 to FLT_MAX) (default 1.04)
  prog_thres ..FV…. set progressive threshold (from -1 to FLT_MAX) (default 1.5)

il AVOptions:
  luma_mode ..FV…. select luma mode (from 0 to 2) (default 0)
     none ..FV….
     interleave ..FV….
     i ..FV….
     deinterleave ..FV….
     d ..FV….
  l ..FV…. select luma mode (from 0 to 2) (default 0)
     none ..FV….
     interleave ..FV….
     i ..FV….
     deinterleave ..FV….
     d ..FV….
  chroma_mode ..FV…. select chroma mode (from 0 to 2) (default 0)
     none ..FV….
     interleave ..FV….
     i ..FV….
     deinterleave ..FV….
     d ..FV….
  c ..FV…. select chroma mode (from 0 to 2) (default 0)
     none ..FV….
     interleave ..FV….
     i ..FV….
     deinterleave ..FV….
     d ..FV….
  alpha_mode ..FV…. select alpha mode (from 0 to 2) (default 0)
     none ..FV….
     interleave ..FV….
     i ..FV….
     deinterleave ..FV….
     d ..FV….
  a ..FV…. select alpha mode (from 0 to 2) (default 0)
     none ..FV….
     interleave ..FV….
     i ..FV….
     deinterleave ..FV….
     d ..FV….
  luma_swap ..FV…. swap luma fields (from 0 to 1) (default 0)
  ls ..FV…. swap luma fields (from 0 to 1) (default 0)
  chroma_swap ..FV…. swap chroma fields (from 0 to 1) (default 0)
  cs ..FV…. swap chroma fields (from 0 to 1) (default 0)
  alpha_swap ..FV…. swap alpha fields (from 0 to 1) (default 0)
  as ..FV…. swap alpha fields (from 0 to 1) (default 0)

interlace AVOptions:
  -scan …V…. scanning mode (from 0 to 1) (default 0)
     tff …V…. top field first
     bff …V…. bottom field first
  -lowpass …V…. (deprecated, this option is always set) (from 0 to 1) (default 1)

interleave AVOptions:
  nb_inputs ..FV…. set number of inputs (from 1 to INT_MAX) (default 2)
  n ..FV…. set number of inputs (from 1 to INT_MAX) (default 2)

kerndeint AVOptions:
  thresh ..FV…. set the threshold (from 0 to 255) (default 10)
  map ..FV…. set the map (from 0 to 1) (default 0)
  order ..FV…. set the order (from 0 to 1) (default 0)
  sharp ..FV…. enable sharpening (from 0 to 1) (default 0)
  twoway ..FV…. enable twoway (from 0 to 1) (default 0)

lut3d AVOptions:
  file ..FV…. set 3D LUT file name
  interp ..FV…. select interpolation mode (from 0 to 2) (default 2)
     nearest ..FV…. use values from the nearest defined points
     trilinear ..FV…. interpolate values using the 8 points defining a cube
     tetrahedral ..FV…. interpolate values using a tetrahedron

lut AVOptions:
  c0 ..FV…. set component #0 expression (default “val”)
  c1 ..FV…. set component #1 expression (default “val”)
  c2 ..FV…. set component #2 expression (default “val”)
  c3 ..FV…. set component #3 expression (default “val”)
  y ..FV…. set Y expression (default “val”)
  u ..FV…. set U expression (default “val”)
  v ..FV…. set V expression (default “val”)
  r ..FV…. set R expression (default “val”)
  g ..FV…. set G expression (default “val”)
  b ..FV…. set B expression (default “val”)
  a ..FV…. set A expression (default “val”)

lutrgb AVOptions:
  c0 ..FV…. set component #0 expression (default “val”)
  c1 ..FV…. set component #1 expression (default “val”)
  c2 ..FV…. set component #2 expression (default “val”)
  c3 ..FV…. set component #3 expression (default “val”)
  y ..FV…. set Y expression (default “val”)
  u ..FV…. set U expression (default “val”)
  v ..FV…. set V expression (default “val”)
  r ..FV…. set R expression (default “val”)
  g ..FV…. set G expression (default “val”)
  b ..FV…. set B expression (default “val”)
  a ..FV…. set A expression (default “val”)

lutyuv AVOptions:
  c0 ..FV…. set component #0 expression (default “val”)
  c1 ..FV…. set component #1 expression (default “val”)
  c2 ..FV…. set component #2 expression (default “val”)
  c3 ..FV…. set component #3 expression (default “val”)
  y ..FV…. set Y expression (default “val”)
  u ..FV…. set U expression (default “val”)
  v ..FV…. set V expression (default “val”)
  r ..FV…. set R expression (default “val”)
  g ..FV…. set G expression (default “val”)
  b ..FV…. set B expression (default “val”)
  a ..FV…. set A expression (default “val”)

mcdeint AVOptions:
  mode ..FV…. set mode (from 0 to 3) (default 0)
     fast ..FV….
     medium ..FV….
     slow ..FV….
     extra_slow ..FV….
  parity ..FV…. set the assumed picture field parity (from -1 to 1) (default 1)
     tff ..FV…. assume top field first
     bff ..FV…. assume bottom field first
  qp ..FV…. set qp (from INT_MIN to INT_MAX) (default 1)

mergeplanes AVOptions:
  mapping ..FV…. set input to output plane mapping (from 0 to 8.58993e+008) (default 0)
  format ..FV…. set output pixel format (default yuva444p)

mp AVOptions:
  filter ..FV…. set MPlayer filter name and parameters

mpdecimate AVOptions:
  max ..FV…. set the maximum number of consecutive dropped frames (positive), or the minimum interval between dropped frames (negative) (from INT_MIN to INT_MAX) (default 0)
  hi ..FV…. set high dropping threshold (from INT_MIN to INT_MAX) (default 768)
  lo ..FV…. set low dropping threshold (from INT_MIN to INT_MAX) (default 320)
  frac ..FV…. set fraction dropping threshold (from 0 to 1) (default 0.33)

negate AVOptions:
  negate_alpha ..FV…. (from 0 to 1) (default 0)

noformat AVOptions:
  -pix_fmts …V…. A ‘|’-separated list of pixel formats

noise AVOptions:
  all_seed ..FV…. set component #0 noise seed (from -1 to INT_MAX) (default -1)
  all_strength ..FV…. set component #0 strength (from 0 to 100) (default 0)
  alls ..FV…. set component #0 strength (from 0 to 100) (default 0)
  all_flags ..FV…. set component #0 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  allf ..FV…. set component #0 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c0_seed ..FV…. set component #0 noise seed (from -1 to INT_MAX) (default -1)
  c0_strength ..FV…. set component #0 strength (from 0 to 100) (default 0)
  c0s ..FV…. set component #0 strength (from 0 to 100) (default 0)
  c0_flags ..FV…. set component #0 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c0f ..FV…. set component #0 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c1_seed ..FV…. set component #1 noise seed (from -1 to INT_MAX) (default -1)
  c1_strength ..FV…. set component #1 strength (from 0 to 100) (default 0)
  c1s ..FV…. set component #1 strength (from 0 to 100) (default 0)
  c1_flags ..FV…. set component #1 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c1f ..FV…. set component #1 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c2_seed ..FV…. set component #2 noise seed (from -1 to INT_MAX) (default -1)
  c2_strength ..FV…. set component #2 strength (from 0 to 100) (default 0)
  c2s ..FV…. set component #2 strength (from 0 to 100) (default 0)
  c2_flags ..FV…. set component #2 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c2f ..FV…. set component #2 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c3_seed ..FV…. set component #3 noise seed (from -1 to INT_MAX) (default -1)
  c3_strength ..FV…. set component #3 strength (from 0 to 100) (default 0)
  c3s ..FV…. set component #3 strength (from 0 to 100) (default 0)
  c3_flags ..FV…. set component #3 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise
  c3f ..FV…. set component #3 flags (default 0)
     a ..FV…. averaged noise
     p ..FV…. (semi)regular pattern
     t ..FV…. temporal noise
     u ..FV…. uniform noise

overlay AVOptions:
  x ..FV…. set the x expression (default “0”)
  y ..FV…. set the y expression (default “0”)
  eof_action ..FV…. Action to take when encountering EOF from secondary input (from 0 to 2) (default 0)
     repeat ..FV…. Repeat the previous frame.
     endall ..FV…. End both streams.
     pass ..FV…. Pass through the main input.
  eval ..FV…. specify when to evaluate expressions (from 0 to 1) (default 1)
     init ..FV…. eval expressions once during initialization
     frame ..FV…. eval expressions per-frame
  rgb ..FV…. force packed RGB in input and output (deprecated) (from 0 to 1) (default 0)
  shortest ..FV…. force termination when the shortest input terminates (from 0 to 1) (default 0)
  format ..FV…. set output format (from 0 to 3) (default 0)
     yuv420 ..FV…. 
     yuv422 ..FV…. 
     yuv444 ..FV…. 
     rgb ..FV…. 
  repeatlast ..FV…. repeat overlay of the last overlay frame (from 0 to 1) (default 1)

owdenoise AVOptions:
  depth ..FV…. set depth (from 8 to 16) (default 8)
  luma_strength ..FV…. set luma strength (from 0 to 1000) (default 1)
  ls ..FV…. set luma strength (from 0 to 1000) (default 1)
  chroma_strength ..FV…. set chroma strength (from 0 to 1000) (default 1)
  cs ..FV…. set chroma strength (from 0 to 1000) (default 1)

pad AVOptions:
  width ..FV…. set the pad area width expression (default “iw”)
  w ..FV…. set the pad area width expression (default “iw”)
  height ..FV…. set the pad area height expression (default “ih”)
  h ..FV…. set the pad area height expression (default “ih”)
  x ..FV…. set the x offset expression for the input image position (default “0”)
  y ..FV…. set the y offset expression for the input image position (default “0”)
  color ..FV…. set the color of the padded area border (default “black”)

perms AVOptions:
  mode ..FVA… select permissions mode (from 0 to 4) (default 0)
     none ..FVA… do nothing
     ro ..FVA… set all output frames read-only
     rw ..FVA… set all output frames writable
     toggle ..FVA… switch permissions
     random ..FVA… set permissions randomly
  seed ..FVA… set the seed for the random mode (from -1 to UINT32_MAX) (default -1)

perspective AVOptions:
  x0 ..FV…. set top left x coordinate (default “0”)
  y0 ..FV…. set top left y coordinate (default “0”)
  x1 ..FV…. set top right x coordinate (default “W”)
  y1 ..FV…. set top right y coordinate (default “0”)
  x2 ..FV…. set bottom left x coordinate (default “0”)
  y2 ..FV…. set bottom left y coordinate (default “H”)
  x3 ..FV…. set bottom right x coordinate (default “W”)
  y3 ..FV…. set bottom right y coordinate (default “H”)
  interpolation ..FV…. set interpolation (from 0 to 1) (default 0)
     linear ..FV…. 
     cubic ..FV….

phase AVOptions:
  mode ..FV…. set phase mode (from 0 to 8) (default 8)
     p ..FV…. progressive
     t ..FV…. top first
     b ..FV…. bottom first
     T ..FV…. top first analyze
     B ..FV…. bottom first analyze
     u ..FV…. analyze
     U ..FV…. full analyze
     a ..FV…. auto
     A ..FV…. auto analyze

pp AVOptions:
  subfilters ..FV…. set postprocess subfilters (default “de”)

psnr AVOptions:
  stats_file ..FV…. Set file where to store per-frame difference information
  f ..FV…. Set file where to store per-frame difference information

pullup AVOptions:
  jl ..FV…. set left junk size (from 0 to INT_MAX) (default 1)
  jr ..FV…. set right junk size (from 0 to INT_MAX) (default 1)
  jt ..FV…. set top junk size (from 1 to INT_MAX) (default 4)
  jb ..FV…. set bottom junk size (from 1 to INT_MAX) (default 4)
  sb ..FV…. set strict breaks (from -1 to 1) (default 0)
  mp ..FV…. set metric plane (from 0 to 2) (default 0)
     y ..FV…. luma
     u ..FV…. chroma blue
     v ..FV…. chroma red

removelogo AVOptions:
  filename ..FV…. set bitmap filename
  f ..FV…. set bitmap filename

rotate AVOptions:
  angle ..FV…. set angle (in radians) (default “0”)
  a ..FV…. set angle (in radians) (default “0”)
  out_w ..FV…. set output width expression (default “iw”)
  ow ..FV…. set output width expression (default “iw”)
  out_h ..FV…. set output height expression (default “ih”)
  oh ..FV…. set output height expression (default “ih”)
  fillcolor ..FV…. set background fill color (default “black”)
  c ..FV…. set background fill color (default “black”)
  bilinear ..FV…. use bilinear interpolation (from 0 to 1) (default 1)

sab AVOptions:
  luma_radius ..FV…. set luma radius (from 0.1 to 4) (default 1)
  lr ..FV…. set luma radius (from 0.1 to 4) (default 1)
  luma_pre_filter_radius ..FV…. set luma pre-filter radius (from 0.1 to 2) (default 1)
  lpfr ..FV…. set luma pre-filter radius (from 0.1 to 2) (default 1)
  luma_strength ..FV…. set luma strength (from 0.1 to 100) (default 1)
  ls ..FV…. set luma strength (from 0.1 to 100) (default 1)
  chroma_radius ..FV…. set chroma radius (from -0.9 to 4) (default -0.9)
  cr ..FV…. set chroma radius (from -0.9 to 4) (default -0.9)
  chroma_pre_filter_radius ..FV…. set chroma pre-filter radius (from -0.9 to 2) (default -0.9)
  cpfr ..FV…. set chroma pre-filter radius (from -0.9 to 2) (default -0.9)
  chroma_strength ..FV…. set chroma strength (from -0.9 to 100) (default -0.9)
  cs ..FV…. set chroma strength (from -0.9 to 100) (default -0.9)

scale AVOptions:
  w ..FV…. Output video width
  width ..FV…. Output video width
  h ..FV…. Output video height
  height ..FV…. Output video height
  flags ..FV…. Flags to pass to libswscale (default “bilinear”)
  interl ..FV…. set interlacing (from -1 to 1) (default 0)
  in_color_matrix ..FV…. set input YCbCr type (default “auto”)
  out_color_matrix ..FV…. set output YCbCr type
  in_range ..FV…. set input color range (from 0 to 2) (default 0)
     auto ..FV….
     full ..FV….
     jpeg ..FV….
     mpeg ..FV….
     tv ..FV….
     pc ..FV….
  out_range ..FV…. set output color range (from 0 to 2) (default 0)
     auto ..FV….
     full ..FV….
     jpeg ..FV….
     mpeg ..FV….
     tv ..FV….
     pc ..FV….
  in_v_chr_pos ..FV…. input vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
  in_h_chr_pos ..FV…. input horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
  out_v_chr_pos ..FV…. output vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
  out_h_chr_pos ..FV…. output horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
  force_original_aspect_ratio ..FV…. decrease or increase w/h if necessary to keep the original AR (from 0 to 2) (default 0)
     disable ..FV….
     decrease ..FV….
     increase ..FV….

SWScaler AVOptions:
  -sws_flags E..V…. scaler flags (default 4)
     fast_bilinear E..V…. fast bilinear
     bilinear E..V…. bilinear
     bicubic E..V…. bicubic
     experimental E..V…. experimental
     neighbor E..V…. nearest neighbor
     area E..V…. averaging area
     bicublin E..V…. luma bicubic, chroma bilinear
     gauss E..V…. gaussian
     sinc E..V…. sinc
     lanczos E..V…. lanczos
     spline E..V…. natural bicubic spline
     print_info E..V…. print info
     accurate_rnd E..V…. accurate rounding
     full_chroma_int E..V…. full chroma interpolation
     full_chroma_inp E..V…. full chroma input
     bitexact E..V…. 
     error_diffusion E..V…. error diffusion dither
  -srcw E..V…. source width (from 1 to INT_MAX) (default 16)
  -srch E..V…. source height (from 1 to INT_MAX) (default 16)
  -dstw E..V…. destination width (from 1 to INT_MAX) (default 16)
  -dsth E..V…. destination height (from 1 to INT_MAX) (default 16)
  -src_format E..V…. source format (from 0 to 332) (default 0)
  -dst_format E..V…. destination format (from 0 to 332) (default 0)
  -src_range E..V…. source range (from 0 to 1) (default 0)
  -dst_range E..V…. destination range (from 0 to 1) (default 0)
  -param0 E..V…. scaler param 0 (from INT_MIN to INT_MAX) (default 123456)
  -param1 E..V…. scaler param 1 (from INT_MIN to INT_MAX) (default 123456)
  -src_v_chr_pos E..V…. source vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
  -src_h_chr_pos E..V…. source horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
  -dst_v_chr_pos E..V…. destination vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
  -dst_h_chr_pos E..V…. destination horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
  -sws_dither E..V…. set dithering algorithm (from 0 to 6) (default 1)
     auto E..V…. leave choice to sws
     bayer E..V…. bayer dither
     ed E..V…. error diffusion
     a_dither E..V…. arithmetic addition dither
     x_dither E..V…. arithmetic xor dither

select AVOptions:
  expr ..FV…. set an expression to use for selecting frames (default “1”)
  e ..FV…. set an expression to use for selecting frames (default “1”)
  outputs ..FV…. set the number of outputs (from 1 to INT_MAX) (default 1)
  n ..FV…. set the number of outputs (from 1 to INT_MAX) (default 1)

sendcmd AVOptions:
  commands ..FVA… set commands
  c ..FVA… set commands
  filename ..FVA… set commands file
  f ..FVA… set commands file

setdar AVOptions:
  dar ..FV…. set display aspect ratio (default “0”)
  ratio ..FV…. set display aspect ratio (default “0”)
  r ..FV…. set display aspect ratio (default “0”)
  dar_den ..FV…. (from 0 to FLT_MAX) (default 0)
  max ..FV…. set max value for nominator or denominator in the ratio (from 1 to INT_MAX) (default 100)

setfield AVOptions:
  mode ..FV…. select interlace mode (from -1 to 2) (default -1)
     auto ..FV…. keep the same input field
     bff ..FV…. mark as bottom-field-first
     tff ..FV…. mark as top-field-first
     prog ..FV…. mark as progressive

setpts AVOptions:
  expr ..FVA… Expression determining the frame timestamp (default “PTS”)

setsar AVOptions:
  sar ..FV…. set sample (pixel) aspect ratio (default “0”)
  ratio ..FV…. set sample (pixel) aspect ratio (default “0”)
  r ..FV…. set sample (pixel) aspect ratio (default “0”)
  sar_den ..FV…. (from 0 to FLT_MAX) (default 0)
  max ..FV…. set max value for nominator or denominator in the ratio (from 1 to INT_MAX) (default 100)

settb AVOptions:
  expr ..FV…. set expression determining the output timebase (default “intb”)
  tb ..FV…. set expression determining the output timebase (default “intb”)

shuffleplanes AVOptions:
  map0 ..FV…. Index of the input plane to be used as the first output plane (from 0 to 4) (default 0)
  map1 ..FV…. Index of the input plane to be used as the second output plane (from 0 to 4) (default 1)
  map2 ..FV…. Index of the input plane to be used as the third output plane (from 0 to 4) (default 2)
  map3 ..FV…. Index of the input plane to be used as the fourth output plane (from 0 to 4) (default 3)

smartblur AVOptions:
  luma_radius ..FV…. set luma radius (from 0.1 to 5) (default 1)
  lr ..FV…. set luma radius (from 0.1 to 5) (default 1)
  luma_strength ..FV…. set luma strength (from -1 to 1) (default 1)
  ls ..FV…. set luma strength (from -1 to 1) (default 1)
  luma_threshold ..FV…. set luma threshold (from -30 to 30) (default 0)
  lt ..FV…. set luma threshold (from -30 to 30) (default 0)
  chroma_radius ..FV…. set chroma radius (from -0.9 to 5) (default -0.9)
  cr ..FV…. set chroma radius (from -0.9 to 5) (default -0.9)
  chroma_strength ..FV…. set chroma strength (from -2 to 1) (default -2)
  cs ..FV…. set chroma strength (from -2 to 1) (default -2)
  chroma_threshold ..FV…. set chroma threshold (from -31 to 30) (default -31)
  ct ..FV…. set chroma threshold (from -31 to 30) (default -31)

split AVOptions:
  -outputs …VA… set number of outputs (from 1 to INT_MAX) (default 2)

spp AVOptions:
  quality ..FV…. set quality (from 0 to 6) (default 3)
  qp ..FV…. force a constant quantizer parameter (from 0 to 63) (default 0)
  mode ..FV…. set thresholding mode (from 0 to 1) (default 0)
     hard ..FV…. hard thresholding
     soft ..FV…. soft thresholding
  use_bframe_qp ..FV…. use B-frames’ QP (from 0 to 1) (default 0)

stereo3d AVOptions:
  in ..FV…. set input format (from 18 to 27) (default 18)
     ab2l ..FV…. above below half height left first
     ab2r ..FV…. above below half height right first
     abl ..FV…. above below left first
     abr ..FV…. above below right first
     al ..FV…. alternating frames left first
     ar ..FV…. alternating frames right first
     sbs2l ..FV…. side by side half width left first
     sbs2r ..FV…. side by side half width right first
     sbsl ..FV…. side by side left first
     sbsr ..FV…. side by side right first
  out ..FV…. set output format (from 0 to 27) (default 3)
     ab2l ..FV…. above below half height left first
     ab2r ..FV…. above below half height right first
     abl ..FV…. above below left first
     abr ..FV…. above below right first
     agmc ..FV…. anaglyph green magenta color
     agmd ..FV…. anaglyph green magenta dubois
     agmg ..FV…. anaglyph green magenta gray
     agmh ..FV…. anaglyph green magenta half color
     al ..FV…. alternating frames left first
     ar ..FV…. alternating frames right first
     arbg ..FV…. anaglyph red blue gray
     arcc ..FV…. anaglyph red cyan color
     arcd ..FV…. anaglyph red cyan dubois
     arcg ..FV…. anaglyph red cyan gray
     arch ..FV…. anaglyph red cyan half color
     argg ..FV…. anaglyph red green gray
     aybc ..FV…. anaglyph yellow blue color
     aybd ..FV…. anaglyph yellow blue dubois
     aybg ..FV…. anaglyph yellow blue gray
     aybh ..FV…. anaglyph yellow blue half color
     irl ..FV…. interleave rows left first
     irr ..FV…. interleave rows right first
     ml ..FV…. mono left
     mr ..FV…. mono right
     sbs2l ..FV…. side by side half width left first
     sbs2r ..FV…. side by side half width right first
     sbsl ..FV…. side by side left first
     sbsr ..FV…. side by side right first

subtitles AVOptions:
  filename ..FV…. set the filename of file to read
  f ..FV…. set the filename of file to read
  original_size ..FV…. set the size of the original video (used to scale fonts)
  charenc ..FV…. set input character encoding

telecine AVOptions:
  first_field ..FV…. select first field (from 0 to 1) (default 0)
     top ..FV…. select top field first
     t ..FV…. select top field first
     bottom ..FV…. select bottom field first
     b ..FV…. select bottom field first
  pattern ..FV…. pattern that describe for how many fields a frame is to be displayed (default “23”)

thumbnail AVOptions:
  n ..FV…. set the frames batch size (from 2 to INT_MAX) (default 100)

tile AVOptions:
  layout ..FV…. set grid size (default “6×5”)
  nb_frames ..FV…. set maximum number of frame to render (from 0 to INT_MAX) (default 0)
  margin ..FV…. set outer border margin in pixels (from 0 to 1024) (default 0)
  padding ..FV…. set inner border thickness in pixels (from 0 to 1024) (default 0)
  color ..FV…. set the color of the unused area (default “black”)

tinterlace AVOptions:
  mode ..FV…. select interlace mode (from 0 to 6) (default 0)
     merge ..FV…. merge fields
     drop_even ..FV…. drop even fields
     drop_odd ..FV…. drop odd fields
     pad ..FV…. pad alternate lines with black
     interleave_top ..FV…. interleave top and bottom fields
     interleave_bottom ..FV…. interleave bottom and top fields
     interlacex2 ..FV…. interlace fields from two consecutive frames

transpose AVOptions:
  dir ..FV…. set transpose direction (from 0 to 7) (default 0)
  passthrough ..FV…. do not apply transposition if the input matches the specified geometry (from 0 to INT_MAX) (default 0)
     none ..FV…. always apply transposition
     portrait ..FV…. preserve portrait geometry
     landscape ..FV…. preserve landscape geometry

trim AVOptions:
  starti ..FV…. Timestamp of the first frame that should be passed (default I64_MAX)
  endi ..FV…. Timestamp of the first frame that should be dropped again (default I64_MAX)
  start_pts ..FV…. Timestamp of the first frame that should be passed (from I64_MIN to I64_MAX) (default I64_MIN)
  end_pts ..FV…. Timestamp of the first frame that should be dropped again (from I64_MIN to I64_MAX) (default I64_MIN)
  durationi ..FV…. Maximum duration of the output (default 0)
  start_frame ..FV…. Number of the first frame that should be passed to the output (from -1 to I64_MAX) (default -1)
  end_frame ..FV…. Number of the first frame that should be dropped again (from 0 to I64_MAX) (default I64_MAX)
  start ..FV…. Timestamp in seconds of the first frame that should be passed (from -DBL_MAX to DBL_MAX) (default DBL_MAX)
  end ..FV…. Timestamp in seconds of the first frame that should be dropped again (from -DBL_MAX to DBL_MAX) (default DBL_MAX)
  duration ..FV…. Maximum duration of the output in seconds (from 0 to DBL_MAX) (default 0)

unsharp AVOptions:
  luma_msize_x ..FV…. set luma matrix horizontal size (from 3 to 63) (default 5)
  lx ..FV…. set luma matrix horizontal size (from 3 to 63) (default 5)
  luma_msize_y ..FV…. set luma matrix vertical size (from 3 to 63) (default 5)
  ly ..FV…. set luma matrix vertical size (from 3 to 63) (default 5)
  luma_amount ..FV…. set luma effect strength (from -2 to 5) (default 1)
  la ..FV…. set luma effect strength (from -2 to 5) (default 1)
  chroma_msize_x ..FV…. set chroma matrix horizontal size (from 3 to 63) (default 5)
  cx ..FV…. set chroma matrix horizontal size (from 3 to 63) (default 5)
  chroma_msize_y ..FV…. set chroma matrix vertical size (from 3 to 63) (default 5)
  cy ..FV…. set chroma matrix vertical size (from 3 to 63) (default 5)
  chroma_amount ..FV…. set chroma effect strength (from -2 to 5) (default 0)
  ca ..FV…. set chroma effect strength (from -2 to 5) (default 0)
  opencl ..FV…. use OpenCL filtering capabilities (from 0 to 1) (default 0)

vidstabdetect AVOptions:
  result ..FV…. path to the file used to write the transforms (default “transforms.trf”)
  shakiness ..FV…. how shaky is the video and how quick is the camera? 1: little (fast) 10: very strong/quick (slow) (from 1 to 10) (default 5)
  accuracy ..FV…. (>=shakiness) 1: low 15: high (slow) (from 1 to 15) (default 15)
  stepsize ..FV…. region around minimum is scanned with 1 pixel resolution (from 1 to 32) (default 6)
  mincontrast ..FV…. below this contrast a field is discarded (0-1) (from 0 to 1) (default 0.25)
  show ..FV…. 0: draw nothing; 1,2: show fields and transforms (from 0 to 2) (default 0)
  tripod ..FV…. virtual tripod mode (if >0): motion is compared to a reference reference frame (frame # is the value) (from 0 to INT_MAX) (default 0)

vidstabtransform AVOptions:
  input ..FV…. set path to the file storing the transforms (default “transforms.trf”)
  smoothing ..FV…. set number of frames*2 + 1 used for lowpass filtering (from 0 to 1000) (default 15)
  optalgo ..FV…. set camera path optimization algo (from 0 to 2) (default 0)
     opt ..FV…. global optimization
     gauss ..FV…. gaussian kernel
     avg ..FV…. simple averaging on motion
  maxshift ..FV…. set maximal number of pixels to translate image (from -1 to 500) (default -1)
  maxangle ..FV…. set maximal angle in rad to rotate image (from -1 to 3.14) (default -1)
  crop ..FV…. set cropping mode (from 0 to 1) (default 0)
     keep ..FV…. keep border
     black ..FV…. black border
  invert ..FV…. invert transforms (from 0 to 1) (default 0)
  relative ..FV…. consider transforms as relative (from 0 to 1) (default 1)
  zoom ..FV…. set percentage to zoom (>0: zoom in, <0: zoom out (from -100 to 100) (default 0)
  optzoom ..FV…. set optimal zoom (0: nothing, 1: optimal static zoom, 2: optimal dynamic zoom) (from 0 to 2) (default 1)
  zoomspeed ..FV…. for adative zoom: percent to zoom maximally each frame (from 0 to 5) (default 0.25)
  interpol ..FV…. set type of interpolation (from 0 to 3) (default 2)
     no ..FV…. no interpolation
     linear ..FV…. linear (horizontal)
     bilinear ..FV…. bi-linear
     bicubic ..FV…. bi-cubic
  tripod ..FV…. enable virtual tripod mode (same as relative=0:smoothing=0) (from 0 to 1) (default 0)
  debug ..FV…. enable debug mode and writer global motions information to file (from 0 to 1) (default 0)

vignette AVOptions:
  angle ..FV…. set lens angle (default “PI/5”)
  a ..FV…. set lens angle (default “PI/5”)
  x0 ..FV…. set circle center position on x-axis (default “w/2”)
  y0 ..FV…. set circle center position on y-axis (default “h/2”)
  mode ..FV…. set forward/backward mode (from 0 to 1) (default 0)
     forward ..FV….
     backward ..FV….
  eval ..FV…. specify when to evaluate expressions (from 0 to 1) (default 0)
     init ..FV…. eval expressions once during initialization
     frame ..FV…. eval expressions for each frame
  dither ..FV…. set dithering (from 0 to 1) (default 1)
  aspect ..FV…. set aspect ratio (from 0 to DBL_MAX) (default 1/1)

w3fdif AVOptions:
  filter ..FV…. specify the filter (from 0 to 1) (default 1)
     simple ..FV….
     complex ..FV….
  deint ..FV…. specify which frames to deinterlace (from 0 to 1) (default 0)
     all ..FV…. deinterlace all frames
     interlaced ..FV…. only deinterlace frames marked as interlaced

yadif AVOptions:
  mode ..FV…. specify the interlacing mode (from 0 to 3) (default 0)
     send_frame ..FV…. send one frame for each frame
     send_field ..FV…. send one frame for each field
     send_frame_nospatial ..FV…. send one frame for each frame, but skip spatial interlacing check
     send_field_nospatial ..FV…. send one frame for each field, but skip spatial interlacing check
  parity ..FV…. specify the assumed picture field parity (from -1 to 1) (default -1)
     tff ..FV…. assume top field first
     bff ..FV…. assume bottom field first
     auto ..FV…. auto detect parity
  deint ..FV…. specify which frames to deinterlace (from 0 to 1) (default 0)
     all ..FV…. deinterlace all frames
     interlaced ..FV…. only deinterlace frames marked as interlaced

cellauto AVOptions:
  filename ..FV…. read initial pattern from file
  f ..FV…. read initial pattern from file
  pattern ..FV…. set initial pattern
  p ..FV…. set initial pattern
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  size ..FV…. set video size
  s ..FV…. set video size
  rule ..FV…. set rule (from 0 to 255) (default 110)
  random_fill_ratio ..FV…. set fill ratio for filling initial grid randomly (from 0 to 1) (default 0.618034)
  ratio ..FV…. set fill ratio for filling initial grid randomly (from 0 to 1) (default 0.618034)
  random_seed ..FV…. set the seed for filling the initial grid randomly (from -1 to UINT32_MAX) (default -1)
  seed ..FV…. set the seed for filling the initial grid randomly (from -1 to UINT32_MAX) (default -1)
  scroll ..FV…. scroll pattern downward (from 0 to 1) (default 1)
  start_full ..FV…. start filling the whole video (from 0 to 1) (default 0)
  full ..FV…. start filling the whole video (from 0 to 1) (default 1)
  stitch ..FV…. stitch boundaries (from 0 to 1) (default 1)

color AVOptions:
  color ..FV…. set color (default “black”)
  c ..FV…. set color (default “black”)
  size ..FV…. set video size (default “320×240”)
  s ..FV…. set video size (default “320×240”)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  sar ..FV…. set video sample aspect ratio (from 0 to INT_MAX) (default 1/1)

frei0r_src AVOptions:
  size ..FV…. Dimensions of the generated video. (default “320×240”)
  framerate ..FV…. (default “25”)
  filter_name ..FV….
  filter_params ..FV….

haldclutsrc AVOptions:
  level ..FV…. set level (from 2 to 8) (default 6)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  sar ..FV…. set video sample aspect ratio (from 0 to INT_MAX) (default 1/1)

life AVOptions:
  filename ..FV…. set source file
  f ..FV…. set source file
  size ..FV…. set video size
  s ..FV…. set video size
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  rule ..FV…. set rule (default “B3/S23”)
  random_fill_ratio ..FV…. set fill ratio for filling initial grid randomly (from 0 to 1) (default 0.618034)
  ratio ..FV…. set fill ratio for filling initial grid randomly (from 0 to 1) (default 0.618034)
  random_seed ..FV…. set the seed for filling the initial grid randomly (from -1 to UINT32_MAX) (default -1)
  seed ..FV…. set the seed for filling the initial grid randomly (from -1 to UINT32_MAX) (default -1)
  stitch ..FV…. stitch boundaries (from 0 to 1) (default 1)
  mold ..FV…. set mold speed for dead cells (from 0 to 255) (default 0)
  life_color ..FV…. set life color (default “white”)
  death_color ..FV…. set death color (default “black”)
  mold_color ..FV…. set mold color (default “black”)

mandelbrot AVOptions:
  size ..FV…. set frame size (default “640×480”)
  s ..FV…. set frame size (default “640×480”)
  rate ..FV…. set frame rate (default “25”)
  r ..FV…. set frame rate (default “25”)
  maxiter ..FV…. set max iterations number (from 1 to INT_MAX) (default 7189)
  start_x ..FV…. set the initial x position (from -100 to 100) (default -0.743644)
  start_y ..FV…. set the initial y position (from -100 to 100) (default -0.131826)
  start_scale ..FV…. set the initial scale value (from 0 to FLT_MAX) (default 3)
  end_scale ..FV…. set the terminal scale value (from 0 to FLT_MAX) (default 0.3)
  end_pts ..FV…. set the terminal pts value (from 0 to I64_MAX) (default 400)
  bailout ..FV…. set the bailout value (from 0 to FLT_MAX) (default 10)
  morphxf ..FV…. set morph x frequency (from -FLT_MAX to FLT_MAX) (default 0.01)
  morphyf ..FV…. set morph y frequency (from -FLT_MAX to FLT_MAX) (default 0.0123)
  morphamp ..FV…. set morph amplitude (from -FLT_MAX to FLT_MAX) (default 0)
  outer ..FV…. set outer coloring mode (from 0 to INT_MAX) (default 1)
     iteration_count ..FV…. set iteration count mode
     normalized_iteration_count ..FV…. set normalized iteration count mode
     white ..FV…. set white mode
     outz ..FV…. set outz mode
  inner ..FV…. set inner coloring mode (from 0 to INT_MAX) (default 3)
     black ..FV…. set black mode
     period ..FV…. set period mode
     convergence ..FV…. show time until convergence
     mincol ..FV…. color based on point closest to the origin of the iterations

mptestsrc AVOptions:
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  test ..FV…. set test to perform (from 0 to INT_MAX) (default 10)
     dc_luma ..FV…. 
     dc_chroma ..FV…. 
     freq_luma ..FV…. 
     freq_chroma ..FV…. 
     amp_luma ..FV…. 
     amp_chroma ..FV…. 
     cbp ..FV…. 
     mv ..FV…. 
     ring1 ..FV…. 
     ring2 ..FV…. 
     all ..FV…. 
  t ..FV…. set test to perform (from 0 to INT_MAX) (default 10)
     dc_luma ..FV…. 
     dc_chroma ..FV…. 
     freq_luma ..FV…. 
     freq_chroma ..FV…. 
     amp_luma ..FV…. 
     amp_chroma ..FV…. 
     cbp ..FV…. 
     mv ..FV…. 
     ring1 ..FV…. 
     ring2 ..FV…. 
     all ..FV….

nullsrc AVOptions:
  size ..FV…. set video size (default “320×240”)
  s ..FV…. set video size (default “320×240”)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  sar ..FV…. set video sample aspect ratio (from 0 to INT_MAX) (default 1/1)

rgbtestsrc AVOptions:
  size ..FV…. set video size (default “320×240”)
  s ..FV…. set video size (default “320×240”)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  sar ..FV…. set video sample aspect ratio (from 0 to INT_MAX) (default 1/1)

smptebars AVOptions:
  size ..FV…. set video size (default “320×240”)
  s ..FV…. set video size (default “320×240”)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  sar ..FV…. set video sample aspect ratio (from 0 to INT_MAX) (default 1/1)

smptehdbars AVOptions:
  size ..FV…. set video size (default “320×240”)
  s ..FV…. set video size (default “320×240”)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  sar ..FV…. set video sample aspect ratio (from 0 to INT_MAX) (default 1/1)

testsrc AVOptions:
  size ..FV…. set video size (default “320×240”)
  s ..FV…. set video size (default “320×240”)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  duration ..FV…. set video duration (default -1)
  d ..FV…. set video duration (default -1)
  sar ..FV…. set video sample aspect ratio (from 0 to INT_MAX) (default 1/1)
  decimals ..FV…. set number of decimals to show (from 0 to 17) (default 0)
  n ..FV…. set number of decimals to show (from 0 to 17) (default 0)

avectorscope AVOptions:
  mode ..FV…. set mode (from 0 to 1) (default 0)
     lissajous ..FV…. 
     lissajous_xy ..FV…. 
  m ..FV…. set mode (from 0 to 1) (default 0)
     lissajous ..FV…. 
     lissajous_xy ..FV…. 
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)
  size ..FV…. set video size (default “400×400”)
  s ..FV…. set video size (default “400×400”)
  rc ..FV…. set red contrast (from 0 to 255) (default 40)
  gc ..FV…. set green contrast (from 0 to 255) (default 160)
  bc ..FV…. set blue contrast (from 0 to 255) (default 80)
  rf ..FV…. set red fade (from 0 to 255) (default 15)
  gf ..FV…. set green fade (from 0 to 255) (default 10)
  bf ..FV…. set blue fade (from 0 to 255) (default 5)
  zoom ..FV…. set zoom factor (from 1 to 10) (default 1)

concat AVOptions:
  n ..FVA… specify the number of segments (from 2 to INT_MAX) (default 2)
  v ..FV…. specify the number of video streams (from 0 to INT_MAX) (default 1)
  a ..F.A… specify the number of audio streams (from 0 to INT_MAX) (default 0)
  unsafe ..FVA… enable unsafe mode (from 0 to INT_MAX) (default 0)

showspectrum AVOptions:
  size ..FV…. set video size (default “640×512”)
  s ..FV…. set video size (default “640×512”)
  slide ..FV…. set sliding mode (from 0 to 1) (default 0)
  mode ..FV…. set channel display mode (from 0 to 1) (default 0)
     combined ..FV…. combined mode
     separate ..FV…. separate mode
  color ..FV…. set channel coloring (from 0 to 1) (default 0)
     channel ..FV…. separate color for each channel
     intensity ..FV…. intensity based coloring
  scale ..FV…. set display scale (from 0 to 3) (default 1)
     sqrt ..FV…. square root
     cbrt ..FV…. cubic root
     log ..FV…. logarithmic
     lin ..FV…. linear
  saturation ..FV…. color saturation multiplier (from -10 to 10) (default 1)
  win_func ..FV…. set window function (from 0 to 3) (default 1)
     hann ..FV…. Hann window
     hamming ..FV…. Hamming window
     blackman ..FV…. Blackman window

showwaves AVOptions:
  size ..FV…. set video size (default “600×240”)
  s ..FV…. set video size (default “600×240”)
  mode ..FV…. select display mode (from 0 to 1) (default 0)
     point ..FV…. draw a point for each sample
     line ..FV…. draw a line for each sample
  n ..FV…. set how many samples to show in the same point (from 0 to INT_MAX) (default 0)
  rate ..FV…. set video rate (default “25”)
  r ..FV…. set video rate (default “25”)

amovie AVOptions:
  filename ..FVA…
  format_name ..FVA… set format name
  f ..FVA… set format name
  stream_index ..FVA… set stream index (from -1 to INT_MAX) (default -1)
  si ..FVA… set stream index (from -1 to INT_MAX) (default -1)
  seek_point ..FVA… set seekpoint (seconds) (from 0 to 9.22337e+012) (default 0)
  sp ..FVA… set seekpoint (seconds) (from 0 to 9.22337e+012) (default 0)
  streams ..FVA… set streams
  s ..FVA… set streams
  loop ..FVA… set loop count (from 0 to INT_MAX) (default 1)

movie AVOptions:
  filename ..FVA…
  format_name ..FVA… set format name
  f ..FVA… set format name
  stream_index ..FVA… set stream index (from -1 to INT_MAX) (default -1)
  si ..FVA… set stream index (from -1 to INT_MAX) (default -1)
  seek_point ..FVA… set seekpoint (seconds) (from 0 to 9.22337e+012) (default 0)
  sp ..FVA… set seekpoint (seconds) (from 0 to 9.22337e+012) (default 0)
  streams ..FVA… set streams
  s ..FVA… set streams
  loop ..FVA… set loop count (from 0 to INT_MAX) (default 1)

ffbuffersink AVOptions:
  pix_fmts ..FV…. set the supported pixel formats

ffabuffersink AVOptions:
  sample_fmts ..FV…. set the supported sample formats
  sample_rates ..FV…. set the supported sample rates
  channel_layouts ..FV…. set the supported channel layouts
  channel_counts ..FV…. set the supported channel counts
  all_channel_counts ..FV…. accept all channel counts (from 0 to 1) (default 0)

abuffer AVOptions:
  time_base ..F.A… (from 0 to INT_MAX) (default 0/1)
  sample_rate ..F.A… (from 0 to INT_MAX) (default 0)
  sample_fmt ..F.A… (default none)
  channel_layout ..F.A…
  channels ..F.A… (from 0 to INT_MAX) (default 0)

buffer AVOptions:
  width ..FV…. (from 0 to INT_MAX) (default 0)
  video_size ..FV….
  height ..FV…. (from 0 to INT_MAX) (default 0)
  pix_fmt ..FV…. (default none)
  time_base_num ..FV…. deprecated, do not use (from 0 to INT_MAX) (default 0)
  time_base_den ..FV…. deprecated, do not use (from 0 to INT_MAX) (default 0)
  sar_num ..FV…. deprecated, do not use (from 0 to INT_MAX) (default 0)
  sar_den ..FV…. deprecated, do not use (from 0 to INT_MAX) (default 0)
  sar ..FV…. sample aspect ratio (from 0 to DBL_MAX) (default 1/1)
  pixel_aspect ..FV…. sample aspect ratio (from 0 to DBL_MAX) (default 1/1)
  time_base ..FV…. (from 0 to DBL_MAX) (default 0/1)
  frame_rate ..FV…. (from 0 to DBL_MAX) (default 0/1)
  sws_param ..FV….

abuffersink AVOptions:
  sample_fmts ..FV…. set the supported sample formats
  sample_rates ..FV…. set the supported sample rates
  channel_layouts ..FV…. set the supported channel layouts
  channel_counts ..FV…. set the supported channel counts
  all_channel_counts ..FV…. accept all channel counts (from 0 to 1) (default 0)

buffersink AVOptions:
  pix_fmts ..FV…. set the supported pixel formats