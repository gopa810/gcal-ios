//#ifndef GCAL_CONST_H___
//#define GCAL_CONST_H___

#pragma mark ===== MATH CONSTANTS =====

// pi
#define pi 3.1415926535897932385
// 2 * pi
#define pi2 6.2831853071795864769
// pi / 180
#define rads 0.0174532925199432958

#pragma mark ===== ASTRO CONSTANTS ====

#define AU 149597869.0


#pragma mark ===== CALENDAR CONSTANTS =====

#define EV_NULL              0x100
#define EV_SUDDHA            0x101
#define EV_UNMILANI          0x102
#define EV_VYANJULI          0x103
#define EV_TRISPRSA          0x104
#define EV_UNMILANI_TRISPRSA 0x105
#define EV_PAKSAVARDHINI     0x106
#define EV_JAYA              0x107
#define EV_JAYANTI           0x108
#define EV_PAPA_NASINI       0x109
#define EV_VIJAYA            0x110

#define FAST_NULL       0x0
#define FAST_NOON       0x1
#define FAST_NOON_VISNU 0x2
#define FAST_SUNSET     0x3
#define FAST_MOONRISE   0x4
#define FAST_DUSK       0x5
#define FAST_MIDNIGHT   0x6
#define FAST_EKADASI    0x7
#define FAST_TODAY      0x8

#define FEAST_NULL     0
#define FEAST_TODAY_FAST_YESTERDAY    1
#define FEAST_TOMMOROW_FAST_TODAY     2

#define SPEC_RETURNRATHA    3
#define SPEC_HERAPANCAMI    4
#define SPEC_GUNDICAMARJANA 5
#define SPEC_GOVARDHANPUJA  6
#define SPEC_VAMANADVADASI  7
#define SPEC_VARAHADVADASI  8
#define SPEC_RAMANAVAMI     9
#define SPEC_JANMASTAMI    10
#define SPEC_RATHAYATRA    11
#define SPEC_GAURAPURNIMA  12
#define SPEC_NANDAUTSAVA   13
#define SPEC_MISRAFESTIVAL 14
#define SPEC_PRABHAPP      15


#define CMASYA_PURN_1_FIRST 0x000011
#define CMASYA_PURN_1_LAST  0x000012
#define CMASYA_PURN_2_FIRST 0x000021
#define CMASYA_PURN_2_LAST  0x000022
#define CMASYA_PURN_3_FIRST 0x000031
#define CMASYA_PURN_3_LAST  0x000032
#define CMASYA_PURN_4_FIRST 0x000041
#define CMASYA_PURN_4_LAST  0x000042

#define CMASYA_PRAT_1_FIRST 0x001100
#define CMASYA_PRAT_1_LAST  0x001200
#define CMASYA_PRAT_2_FIRST 0x002100
#define CMASYA_PRAT_2_LAST  0x002200
#define CMASYA_PRAT_3_FIRST 0x003100
#define CMASYA_PRAT_3_LAST  0x003200
#define CMASYA_PRAT_4_FIRST 0x004100
#define CMASYA_PRAT_4_LAST  0x004200

#define CMASYA_EKAD_1_FIRST 0x110000
#define CMASYA_EKAD_1_LAST  0x120000
#define CMASYA_EKAD_2_FIRST 0x210000
#define CMASYA_EKAD_2_LAST  0x220000
#define CMASYA_EKAD_3_FIRST 0x310000
#define CMASYA_EKAD_3_LAST  0x320000
#define CMASYA_EKAD_4_FIRST 0x410000
#define CMASYA_EKAD_4_LAST  0x420000

#define CMASYA_1_CONT       0x01000000
#define CMASYA_2_CONT       0x02000000
#define CMASYA_3_CONT       0x03000000
#define CMASYA_4_CONT       0x04000000
#define CMASYA_CONT_MASK    0x0f000000


#define CMASYA_PURN_MASK_MASA    0x0000f0
#define CMASYA_PURN_MASK_DAY     0x00000f
#define CMASYA_PURN_MASK         0x0000ff
#define CMASYA_PRAT_MASK_MASA    0x00f000
#define CMASYA_PRAT_MASK_DAY     0x000f00
#define CMASYA_PRAT_MASK         0x00ff00
#define CMASYA_EKAD_MASK         0xff0000
#define CMASYA_EKAD_MASK_MASA    0xf00000
#define CMASYA_EKAD_MASK_DAY     0x0f0000


#define DCEX_NAKSATRA_MIDNIGHT 3
#define DCEX_MOONRISE          4
#define DCEX_SUNRISE           5



#define MADHUSUDANA_MASA 0
#define TRIVIKRAMA_MASA  1
#define VAMANA_MASA      2
#define SRIDHARA_MASA    3
#define HRSIKESA_MASA    4
#define PADMANABHA_MASA  5
#define DAMODARA_MASA    6
#define KESAVA_MASA      7
#define NARAYANA_MASA    8
#define MADHAVA_MASA     9
#define GOVINDA_MASA     10
#define VISNU_MASA       11
#define ADHIKA_MASA      12

#define MESHA_SANKRANTI   0
#define VRSABHA_SANKRANTI 1
#define MITHUNA_SANKRANTI 2
#define KATAKA_SANKRANTI  3
#define SIMHA_SANKRANTI   4
#define KANYA_SANKRANTI   5
#define TULA_SANKRANTI    6
#define VRSCIKA_SANKRANTI 7
#define DHANUS_SANKRANTI  8
#define MAKARA_SANKRANTI  9
#define KUMBHA_SANKRANTI  10
#define MINA_SANKRANTI    11


#define KRSNA_PAKSA            0
#define GAURA_PAKSA            1

#define TITHI_KRSNA_PRATIPAT   0
#define TITHI_KRSNA_DVITIYA    1
#define TITHI_KRSNA_TRITIYA    2
#define TITHI_KRSNA_CATURTI    3
#define TITHI_KRSNA_PANCAMI    4
#define TITHI_KRSNA_SASTI      5
#define TITHI_KRSNA_SAPTAMI    6
#define TITHI_KRSNA_ASTAMI     7
#define TITHI_KRSNA_NAVAMI     8
#define TITHI_KRSNA_DASAMI     9
#define TITHI_KRSNA_EKADASI   10
#define TITHI_KRSNA_DVADASI   11
#define TITHI_KRSNA_TRAYODASI 12
#define TITHI_KRSNA_CATURDASI 13
#define TITHI_AMAVASYA        14
#define TITHI_GAURA_PRATIPAT  15
#define TITHI_GAURA_DVITIYA   16
#define TITHI_GAURA_TRITIYA   17
#define TITHI_GAURA_CATURTI   18
#define TITHI_GAURA_PANCAMI   19
#define TITHI_GAURA_SASTI     20
#define TITHI_GAURA_SAPTAMI   21
#define TITHI_GAURA_ASTAMI    22
#define TITHI_GAURA_NAVAMI    23
#define TITHI_GAURA_DASAMI    24
#define TITHI_GAURA_EKADASI   25
#define TITHI_GAURA_DVADASI   26
#define TITHI_GAURA_TRAYODASI 27
#define TITHI_GAURA_CATURDASI 28
#define TITHI_PURNIMA         29

#define ROHINI_NAKSATRA       3

#define DW_SUNDAY    0
#define DW_MONDAY    1
#define DW_TUESDAY   2
#define DW_WEDNESDAY 3
#define DW_THURSDAY  4
#define DW_FRIDAY    5
#define DW_SATURDAY  6

#define TITHI_EKADASI(a) (((a) == 10) || ((a) == 25))
#define TITHI_DVADASI(a) (((a) == 11) || ((a) == 26))
#define TITHI_TRAYODASI(a) (((a) == 12) || ((a) == 27))
#define TITHI_CATURDASI(a) (((a) == 13) || ((a) == 28))

#define TITHI_LESS_EKADASI(a) (((a) == 9) || ((a) == 24) || ((a) == 8) || ((a) == 23))
#define TITHI_LESS_DVADASI(a) (((a) == 10) || ((a) == 25) || ((a) == 9) || ((a) == 24))
#define TITHI_LESS_TRAYODASI(a) (((a) == 11) || ((a) == 26) || ((a) == 10) || ((a) == 25))
#define TITHI_FULLNEW_MOON(a) (((a) == 14) || ((a) == 29))

#define PREV_PREV_TITHI(a) (((a) + 28) % 30)
#define PREV_TITHI(a) (((a) + 29) % 30)
#define NEXT_TITHI(a) (((a) + 1) % 30)
#define NEXT_NEXT_TITHI(a) (((a) + 1) % 30)

#define TITHI_LESS_THAN(a,b) (((a) == PREV_TITHI(b)) || ((a) == PREV_PREV_TITHI(b)))
#define TITHI_GREAT_THAN(a,b) (((a) == NEXT_TITHI(b)) || ((a) == NEXT_NEXT_TITHI(b)))

// TRUE when transit from A to B is between T and U
#define TITHI_TRANSIT(t,u,a,b) (((t)==(a)) && ((u)==(b))) || (((t)==(a)) && ((u)==NEXT_TITHI(b))) || (((t)==PREV_TITHI(a)) && ((u) == (b)))



#define CDB_MAXDAYS 16
#define BEFORE_DAYS 8


#define TRESULT_APP_CELEBS 30


#define CCE_SUN  0x0001
#define CCE_TIT  0x0002
#define CCE_NAK  0x0004
#define CCE_SNK  0x0008
#define CCE_CNJ  0x0010
#define CCE_SORT 0x0100
#define CCE_ALL  0x0fff

#define CCTYPE_DATE 1
#define CCTYPE_S_ARUN 10
#define CCTYPE_S_RISE 11
#define CCTYPE_S_NOON 12
#define CCTYPE_S_SET  13
#define CCTYPE_TITHI  20
#define CCTYPE_NAKS   21
#define CCTYPE_SANK   22
#define CCTYPE_CONJ   23



//#endif