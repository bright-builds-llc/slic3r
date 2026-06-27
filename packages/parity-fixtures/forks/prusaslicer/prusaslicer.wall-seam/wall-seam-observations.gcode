; wall-seam observation fixture
; source_anchor:SeamAligned.cpp#L16;SeamAligned.cpp#L115-L148;SeamAligned.cpp#L272-L313;SeamAligned.cpp#L463-L525
; layer_context:layer=0;z=0.200
G1 X12.500 Y8.000 Z0.200 E0.12000 F1800 ; seam_start
G0 X14.000 Y8.750 F9000 ; travel_after_seam
G1 X15.250 Y9.500 E0.28000 F1800 ; seam_resume
G1 E0.24000 F2100 ; retraction_marker
