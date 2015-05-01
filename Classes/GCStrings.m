//
//  GCStrings.m
//  gcal
//
//  Created by Gopal on 20.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCStrings.h"
#import "gc_const.h"
//#import "GcDayFestival.h"
#import "GCDisplaySettings.h"
#import "GcStringRec.h"
#import "BalaCalAppDelegate.h"



@implementation GCStrings

-(id)init
{
	NSLog(@"init strings");
	if ((self = [super init]) != nil) {
		[self clearMappedStrings];
	}
	return self;
}

+(GCStrings *)shared
{
    BalaCalAppDelegate * d = (BalaCalAppDelegate *)[[UIApplication sharedApplication] delegate];
    return d.gstrings;
}

-(void)clearMappedStrings
{
	for(int i = 0; i < GCAL_MAX_GSTRINGS; i++)
	{
		_mapped[i] = @"";
//		_descr[i] = @"";
	}
}

-(BOOL)correctIndex:(int)nIndex
{
	return (nIndex >= 0 && nIndex < GCAL_MAX_GSTRINGS ? YES : NO);
}

-(void)prepareStrings
{
	[self clearMappedStrings];
	[self initGlobalStrings];
/*	for(GcStringRec * p in [_gstr arrangedObjects])
	{
		if ([self correctIndex:p.index]) {
			NSString * val = p.text;
			if (val)
				_mapped[p.index] = val;
			else {
				_mapped[p.index] = @"";
			}
			val = p.desc;
			if (val) _descr[p.index] = val;
			else _descr[p.index] = @"";
		}
	}*/
}

-(void)initGlobalStrings
{
	// days of week
	_mapped[0] = @"Sunday";
	_mapped[1] = @"Monday";
	_mapped[2] = @"Tuesday";
	_mapped[3] = @"Wednesday";
	_mapped[4] = @"Thursday";
	_mapped[5] = @"Friday";
	_mapped[6] = @"Saturday";
	
	_mapped[7] = @"Date";
	_mapped[8] = @"Time";
	_mapped[9] = @"Location";
	_mapped[10]= @"Latitude";
	_mapped[11]= @"Longitude";
	_mapped[12] = @"Timezone";
	_mapped[13] = @"Tithi";
	_mapped[14] = @"Tithi Elaps.";
	_mapped[15] = @"Naksatra";
	_mapped[16] = @"Naksatra Elaps.";
	_mapped[17] = @"Child Name";
	_mapped[18] = @"(according naksatra)";
	_mapped[19] = @"(according rasi)";
	_mapped[20] = @"Paksa";
	_mapped[21] = @"(during Purusottama Adhika Masa)";
	_mapped[22] = @"Masa";
	_mapped[23] = @"Gaurabda Year";
	_mapped[24] = @"Celebrations";
	_mapped[25] = @"Appearance Day Calculation";
	_mapped[26] = @"Day can be only from 1 to 31";
	_mapped[27] = @"Month can be only from 1 to 12";
	_mapped[28] = @"Year can be only from 1500 to 3999";
	_mapped[29] = @"Given date was corrected, since date given by you was nonexisting.";
	_mapped[30] = @"days";
	_mapped[31] = @"months";
	_mapped[32] = @"years";
	_mapped[33] = @"exactly given date";
	_mapped[34] = @"from begining of the month";
	_mapped[35] = @"align to the start of the Masa";
	_mapped[36] = @"from begining of the year";
	_mapped[37] = @"start from first day of the Gaurabda Year";
	_mapped[38] = @"<all mahadvadasis>";
	_mapped[39] = @"Masa Listing";
	_mapped[40] = @"Location";
	_mapped[41] = @"From";
	_mapped[42] = @"To";
	_mapped[43] = @"Today";
	_mapped[44] = @" Calendar";
	_mapped[45] = @" Appearance Day";
	_mapped[46] = @" Core Events";
	_mapped[47] = @"";
	_mapped[48] = @" Masa List";
	_mapped[49] = @"";
	_mapped[50] = @"Could not create new window.";
	_mapped[51] = @"Sunrise";
	_mapped[52] = @"Sunset";
	_mapped[53] = @"Moonrise";
	_mapped[54] = @"Moonset";
	_mapped[55] = @"Year";
	_mapped[56] = @"Sankranti";
	_mapped[57] = @"Please update GCAL to the latest version from http://www.krishnadays.com";
	_mapped[58] = @"(not suitable for fasting)";
	_mapped[59] = @"(suitable for fasting)";
	_mapped[60] = @"Break fast";
	_mapped[61] = @"Break fast after";
	_mapped[62] = @"Break fast not calculated";
	_mapped[63] = @"(DST not considered)";
	
	
	_mapped[64] = @"";
	_mapped[65] = @"Jan";
	_mapped[66] = @"Feb";
	_mapped[67] = @"Mar";
	_mapped[68] = @"Apr";
	_mapped[69] = @"May";
	_mapped[70] = @"Jun";
	_mapped[71] = @"Jul";
	_mapped[72] = @"Aug";
	_mapped[73] = @"Sep";
	_mapped[74] = @"Oct";
	_mapped[75] = @"Nov";
	_mapped[76] = @"Dec";
	
	
	_mapped[78] = @"Ganga Sagara Mela";
	_mapped[79] = @"Tulasi Jala Dan begins.";
	_mapped[80] = @"Tulasi Jala Dan ends.";
	_mapped[81] = @"First day of Bhisma Pancaka";
	_mapped[82] = @"Last day of Bhisma Pancaka";
	_mapped[83] = @"Looking for";
	_mapped[84] = @"Start";
	_mapped[85] = @"End";
	_mapped[86] = @"Not found in this year.";
	_mapped[87] = @"Fasting for";
	_mapped[88] = @"(Fasting is done yesterday, today is feast)";
	_mapped[89] = @"Ksaya tithi";
	_mapped[90] = @"[Second day of Tithi]";
	
	_mapped[91] = @"First day";
	_mapped[92] = @"Last day";
	_mapped[93] = @"of the first month";
	_mapped[94] = @"of the second month";
	_mapped[95] = @"of the third month";
	_mapped[96] = @"of the fourth month";
	_mapped[97] = @"of Caturmasya-vrata";
	
	_mapped[98] = @"Arunodaya Tithi";
	_mapped[99] = @"Arunodaya at";
	_mapped[100] = @"Sun Longitude";
	_mapped[101] = @"Moon Longitude";
	_mapped[102] = @"Ayanamsa";
	_mapped[103] = @"Julian day";
	_mapped[104] = @"Yoga";
	_mapped[105] = @"Rasi";
	
	_mapped[106] = @"(Daylight Saving Time not considered)";
	_mapped[107] = @"(Winter Time)";
	_mapped[108] = @"(Summer Time)";
	_mapped[109] = @"(Second half)";
	
	_mapped[110] = @"Event Finder";
	_mapped[111] = @"Sun enters";
	
	_mapped[112] = @"First month of Caturmasya begins";
	_mapped[113] = @"Last day of the first Caturmasya month";
	_mapped[114] = @"(green leafy vegetable fast for one month)";
	_mapped[115] = @"First month of Caturmasya continues";
	
	_mapped[116] = @"Second month of Caturmasya begins";
	_mapped[117] = @"Last day of the second Caturmasya month";
	_mapped[118] = @"(yogurt fast for one month)";
	_mapped[119] = @"Second month of Caturmasya continues";
	
	_mapped[120] = @"Third month of Caturmasya begins";
	_mapped[121] = @"Last day of the third Caturmasya month";
	_mapped[122] = @"(milk fast for one month)";
	_mapped[123] = @"Third month of Caturmasya continues";
	
	_mapped[124] = @"Fourth month of Caturmasya begins";
	_mapped[125] = @"Last day of the fourth Caturmasya month";
	_mapped[126] = @"(urad dal fast for one month)";
	_mapped[127] = @"Fourth month of Caturmasya continues";
	
	_mapped[128] = @"(Caturmasya is not observed during Purusottama Adhika Masa.)";
	_mapped[129] = @"1";
	_mapped[130] = @"GCal 1";
	_mapped[131] = @"Gaurabda Calendar 1";
	
	_mapped[132] = @"<all sankrantis>";
	_mapped[133] = @"<all tithis>";
	_mapped[134] = @"<all fasting days>";
	_mapped[135] = @"(Fasting for Ekadasi)";
	
	_mapped[136] = @"No Moonrise";
	_mapped[137] = @"No Moonset";
	_mapped[138] = @"No Sunrise";
	_mapped[139] = @"No Sunset";
	
	_mapped[140] = @"SUN - MOON CONJUNCTIONS";
	
	_mapped[150] = @"Su";
	_mapped[151] = @"Mo";
	_mapped[152] = @"Tu";
	_mapped[153] = @"We";
	_mapped[154] = @"Th";
	_mapped[155] = @"Fr";
	_mapped[156] = @"Sa";
	
	_mapped[157] = @"DATE";
	_mapped[158] = @"SUNRISE";
	_mapped[159] = @"MASA";
	_mapped[160] = @"TITHI START";
	_mapped[161] = @"NAKSATRA START";
	
	_mapped[162] = @"Page";
	
	// mena ekadasi
	_mapped[560] = @"Varuthini Ekadasi";
	_mapped[561] = @"Mohini Ekadasi";
	_mapped[562] = @"Apara Ekadasi";
	_mapped[563] = @"Pandava Nirjala Ekadasi#(Total fast, even from water, if you have broken Ekadasi)";
	_mapped[564] = @"Yogini Ekadasi";
	_mapped[565] = @"Sayana Ekadasi";
	_mapped[566] = @"Kamika Ekadasi";
	_mapped[567] = @"Pavitropana Ekadasi";
	_mapped[568] = @"Annada Ekadasi";
	_mapped[569] = @"Parsva Ekadasi";
	_mapped[570] = @"Indira Ekadasi";
	_mapped[571] = @"Pasankusa Ekadasi";
	_mapped[572] = @"Rama Ekadasi";
	_mapped[573] = @"Utthana Ekadasi";
	_mapped[574] = @"Utpanna Ekadasi";
	_mapped[575] = @"Moksada Ekadasi";
	_mapped[576] = @"Saphala Ekadasi";
	_mapped[577] = @"Putrada Ekadasi";
	_mapped[578] = @"Sat-tila Ekadasi";
	_mapped[579] = @"Bhaimi Ekadasi";
	_mapped[580] = @"Vijaya Ekadasi";
	_mapped[581] = @"Amalaki vrata Ekadasi";
	_mapped[582] = @"Papamocani Ekadasi";
	_mapped[583] = @"Kamada Ekadasi";
	_mapped[584] = @"Parama Ekadasi";
	_mapped[585] = @"Padmini Ekadasi";
	
	_mapped[600] = @"Pratipat";
	_mapped[601] = @"Dvitiya";
	_mapped[602] = @"Tritiya";
	_mapped[603] = @"Caturthi";
	_mapped[604] = @"Pancami";
	_mapped[605] = @"Sasti";
	_mapped[606] = @"Saptami";
	_mapped[607] = @"Astami";
	_mapped[608] = @"Navami";
	_mapped[609] = @"Dasami";
	_mapped[610] = @"Ekadasi";
	_mapped[611] = @"Dvadasi";
	_mapped[612] = @"Trayodasi";
	_mapped[613] = @"Caturdasi";
	_mapped[614] = @"Amavasya";
	_mapped[615] = @"Pratipat";
	_mapped[616] = @"Dvitiya";
	_mapped[617] = @"Tritiya";
	_mapped[618] = @"Caturthi";
	_mapped[619] = @"Pancami";
	_mapped[620] = @"Sasti";
	_mapped[621] = @"Saptami";
	_mapped[622] = @"Astami";
	_mapped[623] = @"Navami";
	_mapped[624] = @"Dasami";
	_mapped[625] = @"Ekadasi";
	_mapped[626] = @"Dvadasi";
	_mapped[627] = @"Trayodasi";
	_mapped[628] = @"Caturdasi";
	_mapped[629] = @"Purnima";
	
	// naksatras
	_mapped[630] = @"Asvini";
	_mapped[631] = @"Bharani";
	_mapped[632] = @"Krittika";
	_mapped[633] = @"Rohini";
	_mapped[634] = @"Mrigasira";
	_mapped[635] = @"Ardra";
	_mapped[636] = @"Punarvasu";
	_mapped[637] = @"Pusyami";
	_mapped[638] = @"Aslesa";
	_mapped[639] = @"Magha";
	_mapped[640] = @"Purva-phalguni";
	_mapped[641] = @"Uttara-phalguni";
	_mapped[642] = @"Hasta";
	_mapped[643] = @"Citra";
	_mapped[644] = @"Swati";
	_mapped[645] = @"Visakha";
	_mapped[646] = @"Anuradha";
	_mapped[647] = @"Jyestha";
	_mapped[648] = @"Mula";
	_mapped[649] = @"Purva-asadha";
	_mapped[650] = @"Uttara-asadha";  
	_mapped[651] = @"Sravana";
	_mapped[652] = @"Dhanista";
	_mapped[653] = @"Satabhisa";
	_mapped[654] = @"Purva-bhadra";
	_mapped[655] = @"Uttara-bhadra";
	_mapped[656] = @"Revati";
	
	//yoga
	_mapped[660] = @"Viskumba";
	_mapped[661] = @"Priti"; 
	_mapped[662] = @"Ayusmana";
	_mapped[663] = @"Saubhagya";
	_mapped[664] = @"Sobana";
	_mapped[665] = @"Atiganda";
	_mapped[666] = @"Sukarma";
	_mapped[667] = @"Dhriti";
	_mapped[668] = @"Sula";
	_mapped[669] = @"Ganda";
	_mapped[670] = @"Vriddhi";
	_mapped[671] = @"Dhruva";
	_mapped[672] = @"Vyagata"; 
	_mapped[673] = @"Harsana"; 
	_mapped[674] = @"Vajra"; 
	_mapped[675] = @"Siddhi"; 
	_mapped[676] = @"Vyatipata"; 
	_mapped[677] = @"Variyana"; 
	_mapped[678] = @"Parigha"; 
	_mapped[679] = @"Siva"; 
	_mapped[680] = @"Siddha"; 
	_mapped[681] = @"Sadhya"; 
	_mapped[682] = @"Subha";
	_mapped[683] = @"Sukla"; 
	_mapped[684] = @"Brahma";
	_mapped[685] = @"Indra"; 
	_mapped[686] = @"Vaidhriti";
	
	// rasi
	_mapped[688] = @"Mesa";
	_mapped[689] = @"Vrsabha";
	_mapped[690] = @"Mithuna";
	_mapped[691] = @"Karka";
	_mapped[692] = @"Simha";
	_mapped[693] = @"Kanya";
	_mapped[694] = @"Tula";
	_mapped[695] = @"Vrscika";
	_mapped[696] = @"Dhanus";
	_mapped[697] = @"Makara";
	_mapped[698] = @"Kumbha";
	_mapped[699] = @"Mina";
	
	// rasi eng
	_mapped[700] = @"Aries",
	_mapped[701] = @"Taurus",
	_mapped[702] = @"Gemini",
	_mapped[703] = @"Cancer",
	_mapped[704] = @"Leo",
	_mapped[705] = @"Virgo",
	_mapped[706] = @"Libra",
	_mapped[707] = @"Scorpio",
	_mapped[708] = @"Sagittarius",
	_mapped[709] = @"Capricorn",
	_mapped[710] = @"Aquarius",
	_mapped[711] = @"Pisces";
	
	// paksa
	_mapped[712] = @"Gaura";
	_mapped[713] = @"Krsna";
	
	//masa
	_mapped[720] = @"Madhusudana";
	_mapped[721] = @"Trivikrama";
	_mapped[722] = @"Vamana";
	_mapped[723] = @"Sridhara";
	_mapped[724] = @"Hrsikesa";
	_mapped[725] = @"Padmanabha";
	_mapped[726] = @"Damodara";
	_mapped[727] = @"Kesava";
	_mapped[728] = @"Narayana";
	_mapped[729] = @"Madhava";
	_mapped[730] = @"Govinda";
	_mapped[731] = @"Visnu";
	_mapped[732] = @"Purusottama-adhika";
	
	// mahadvadasi
	_mapped[733] = @"Unmilani Mahadvadasi";
	_mapped[734] = @"Trisprsa Mahadvadasi";
	_mapped[735] = @"Paksa vardhini Mahadvadasi";
	_mapped[736] = @"Jaya Mahadvadasi";
	_mapped[737] = @"Vijaya Mahadvadasi";
	_mapped[738] = @"Papa Nasini Mahadvadasi";
	_mapped[739] = @"Jayanti Mahadvadasi";
	_mapped[740] = @"Vyanjuli Mahadvadasi";
	
	_mapped[741] = @"Sri Krsna Janmastami: Appearance of Lord Sri Krsna";
	_mapped[742] = @"Gaura Purnima: Appearance of Sri Caitanya Mahaprabhu";
	_mapped[743] = @"Return Ratha (8 days after Ratha Yatra)";
	_mapped[744] = @"Hera Pancami (4 days after Ratha Yatra)";
	_mapped[745] = @"Gundica Marjana";
	_mapped[746] = @"Go Puja. Go Krda. Govardhana Puja.";
	_mapped[747] = @"Rama Navami: Appearance of Lord Sri Ramacandra";
	_mapped[748] = @"Ratha Yatra";
	_mapped[749] = @"Nandotsava";
	_mapped[750] = @"Festival of Jagannatha Misra";
	
	_mapped[751] = @"(Fast till noon)";
	_mapped[752] = @"(Fast till sunset)";
	_mapped[753] = @"(Fast till moonrise)";
	_mapped[754] = @"(Fast till dusk)";
	_mapped[755] = @"(Fast till midnight)";
	_mapped[756] = @"(Fast today)";
	
	_mapped[759] = @"Srila Prabhupada -- Appearance";
	
	_mapped[760] = @"January";
	_mapped[761] = @"February";
	_mapped[762] = @"March";
	_mapped[763] = @"April";
	_mapped[764] = @"May";
	_mapped[765] = @"June";
	_mapped[766] = @"July";
	_mapped[767] = @"August";
	_mapped[768] = @"September";
	_mapped[769] = @"October";
	_mapped[770] = @"November";
	_mapped[771] = @"December";
	
	_mapped[780] = @"First day of";
	_mapped[781] = @"Last day of";
	
	_mapped[782] = @"first"; // 2. pad
	_mapped[783] = @"second";
	_mapped[784] = @"third";
	_mapped[785] = @"fourth";
	_mapped[786] = @"last";
	
	_mapped[787] = @"Sunday"; // 2.pad
	_mapped[788] = @"Monday";
	_mapped[789] = @"Tuesday";
	_mapped[790] = @"Wednesday";
	_mapped[791] = @"Thursday";
	_mapped[792] = @"Friday";
	_mapped[793] = @"Saturday";
	
	_mapped[795] = @"of January";
	_mapped[796] = @"of February";
	_mapped[797] = @"of March";
	_mapped[798] = @"of April";
	_mapped[799] = @"of May";
	_mapped[800] = @"of June";
	_mapped[801] = @"of July";
	_mapped[802] = @"of August";
	_mapped[803] = @"of September";
	_mapped[804] = @"of October";
	_mapped[805] = @"of November";
	_mapped[806] = @"of December";
	
	_mapped[807] = @"For this location is Daylight Saving Time not observed.";
	_mapped[808] = @"Daylight saving time is observed ";
	
	_mapped[810] = @"0th";
	_mapped[811] = @"1st";
	_mapped[812] = @"2nd";
	_mapped[813] = @"3rd";
	_mapped[814] = @"4th";
	_mapped[815] = @"5th";
	_mapped[816] = @"6th";
	_mapped[817] = @"7th";
	_mapped[818] = @"8th";
	_mapped[819] = @"9th";
	_mapped[820] = @"10th";
	_mapped[821] = @"11th";
	_mapped[822] = @"12th";
	_mapped[823] = @"13th";
	_mapped[824] = @"14th";
	_mapped[825] = @"15th";
	_mapped[826] = @"16th";
	_mapped[827] = @"17th";
	_mapped[828] = @"18th";
	_mapped[829] = @"19th";
	_mapped[830] = @"20th";
	_mapped[831] = @"21st";
	_mapped[832] = @"22nd";
	_mapped[833] = @"23rd";
	_mapped[834] = @"24th";
	_mapped[835] = @"25th";
	_mapped[836] = @"26th";
	_mapped[837] = @"27th";
	_mapped[838] = @"28th";
	_mapped[839] = @"29th";
	_mapped[840] = @"30th";
	_mapped[841] = @"31st";
	
	_mapped[850] = @"since";
	_mapped[851] = @"to";
	_mapped[852] = @"on";
	
	_mapped[853] = @"Yesterday";
	_mapped[854] = @"Tomorrow";
	_mapped[855] = @"First day of Daylight Saving Time";
	_mapped[856] = @"Last day of Daylight Saving Time";
	_mapped[857] = @"Noon";
	
	_mapped[860] = @"(Fasting is done yesterday)";
	_mapped[861] = @"(Fasting is done yesterday, today is feast)";
	_mapped[862] = @"(Fasting till noon, with feast tomorrow)";
	
	_mapped[870] = @"Chaitra";
	_mapped[871] = @"Vaisakha";
	_mapped[872] = @"Jyeshta";
	_mapped[873] = @"Aashaadha";
	_mapped[874] = @"Shraavana";
	_mapped[875] = @"Bhadrapada";
	_mapped[876] = @"Ashwin";
	_mapped[877] = @"Kartik";
	_mapped[878] = @"Margashirsha";
	_mapped[879] = @"Pasha";
	_mapped[880] = @"Magh";
	_mapped[881] = @"Phalguna";
	
}


#pragma mark ===== getter functions =====

-(NSString *)string:(int)nIndex
{
	if ([self correctIndex:nIndex])
		return _mapped[nIndex];
	else 
		return @"";
}

-(NSString *)GetTithiName:(int)i
{
	return [self string:(600 + i % 30)];
}

-(NSString *)GetMonthAbr:(int)n
{
	return [self string:(64 + n)];
}

-(NSString *)GetDSTSignature:(int)nDST
{
	return nDST ? @"DST" : @"LT";
}

-(NSString *)GetNaksatraName:(int)n
{
	return [self string:(630 + n % 27)];
}

-(NSString *)GetNaksatraChildSylable:(int)n forPada:(int)pada
{
	int i = (n * 4 + pada) % 108;
	
	NSString * childsylable[108] = {
		@"chu",@"che",@"cho",@"la", //asvini
		@"li",@"lu",@"le",@"lo", // bharani
		@"a",@"i",@"u",@"e", //krtika
		@"o",@"va",@"vi",@"vo", // rohini
		@"ve",@"vo",@"ka",@"ke", // mrgasira
		@"ku",@"gha",@"ng",@"chha", // ardra
		@"ke",@"ko",@"ha",@"hi", // punarvasu
		@"hu",@"he",@"ho",@"da", // pushya
		@"di",@"du",@"de",@"do", //aslesa
		@"ma",@"mi",@"mu",@"me", //magha
		@"mo",@"ta",@"ti",@"tu", //purvaphalguni
		@"te",@"to",@"pa",@"pi", //uttaraphalguni
		@"pu",@"sha",@"na",@"tha",//hasta
		@"pe",@"po",@"ra",@"ri",//chitra
		@"ru",@"re",@"ra",@"ta",//svati
		@"ti",@"tu",@"te",@"to",//visakha
		@"na",@"ni",@"nu",@"ne",// anuradha
		@"no",@"ya",@"yi",@"yu",//jyestha
		@"ye",@"yo",@"ba",@"bi",// mula
		@"bu",@"dha",@"bha",@"dha",//purvasada
		@"be",@"bo",@"ja",@"ji",// uttarasada
		@"ju",@"je",@"jo",@"gha",//sravana
		@"ga",@"gi",@"gu",@"ge",// dhanistha
		@"go",@"sa",@"si",@"su",//satabhisda
		@"se",@"so",@"da",@"di",//purvabhadra
		@"du",@"tha",@"jna",@"da",//uttarabhadra
		@"de",@"do",@"cha",@"chi"// revati
		
	};
	
	return childsylable[i];
}

-(NSString *)GetRasiChildSylable:(int)n
{
	NSString * childsylable[12] = {
		@"a... la",
		@"u... va... i... e... o",
		@"ka... cha... gha",
		@"ha",
		@"ma",
		@"pa",
		@"ra... ta",
		@"na... ba",
		@"dha... bha... pha",
		@"kha... ja",
		@"ga... sa",
		@"da... ca... jha"
	};
	/*Mesa :	 	 a   la
	 Vrsabha: 	   u   va,   i, e, o
	 Mithuna:  	 ka,  cha, gha
	 Kataka:	   ha
	 Simha:		  ma
	 Kanya:		 pa
	 Tula:		 ra , ta
	 Vrschika:	  na ,  ba
	 
	 Dhanus:	   dha , bha,  pha
	 Makra:  	kha, ja
	 Kumbha:	   ga,, sa
	 Mina:		  da, ca , jha
	 */		
	
	return childsylable[n % 12];
}

-(NSString *)GetYogaName:(int)n
{
	return [self string:(660 + n % 27)];
}

-(NSString *)GetSankrantiName:(int)i
{
	return [self string:(688 + i % 12)];
}

-(NSString *)GetSankrantiNameEn:(int)i
{
	
	return [self string:(700 + i % 12)];
}

-(char)GetPaksaChar:(int)i
{
	return (i ? 'G' : 'K');
}

-(NSString *)GetPaksaName:(int)i
{
	return (i ? [self string:712] : [self string:713]);
}

-(NSString *)GetMasaName:(int)i
{
	return [self string:(720 + i % 13)];
	
}

-(NSString *)GetMahadvadasiName:(int)i
{
	switch(i)
	{
		case EV_NULL:
		case EV_SUDDHA:
			return NULL;
		case EV_UNMILANI:
			return [self string:733];
		case EV_TRISPRSA:
		case EV_UNMILANI_TRISPRSA:
			return [self string:734];
		case EV_PAKSAVARDHINI:
			return [self string:735];
		case EV_JAYA:
			return [self string:736];
		case EV_VIJAYA:
			return [self string:737];
		case EV_PAPA_NASINI:
			return [self string:738];
		case EV_JAYANTI:
			return [self string:739];
		case EV_VYANJULI:
			return [self string:740];
		default:
			return NULL;
	}
}

-(NSString *)GetSpecFestivalName:(int)i
{
	switch(i)
	{
		case SPEC_JANMASTAMI:
			return [self string:741];
		case SPEC_GAURAPURNIMA:
			return [self string:742];
		case SPEC_RETURNRATHA:
			return [self string:743];
		case SPEC_HERAPANCAMI:
			return [self string:744];
		case SPEC_GUNDICAMARJANA:
			return [self string:745];
		case SPEC_GOVARDHANPUJA:
			return [self string:746];
		case SPEC_RAMANAVAMI:
			return [self string:747];
		case SPEC_RATHAYATRA:
			return [self string:748];
		case SPEC_NANDAUTSAVA:
			return [self string:749];
		case SPEC_PRABHAPP:
			return [self string:759];
		case SPEC_MISRAFESTIVAL:
			return [self string:750];
		default:
			return [self string:64];
	}
}


-(NSString *)GetFastingName:(int)i
{
	switch (i)
	{
		case FAST_NOON:
			return [self string:751];
		case FAST_NOON_VISNU:
			return [self string:751];
		case FAST_SUNSET:
			return [self string:752];
		case FAST_MOONRISE:
			return [self string:753];
		case FAST_DUSK:
			return [self string:754];
		case FAST_MIDNIGHT:
			return [self string:755];
		case FAST_TODAY:
			return [self string:756];
		default:
			return nil;
	}
}

-(NSString *)GetEkadasiName:(int)nMasa forPaksa:(int)nPaksa
{
	return [self string:(560 + nMasa*2 + nPaksa)];
}

-(NSString *)GetVersionText
{
	return [self string:130];
}

-(NSString *)GetTextLatitude:(double)d
{
	int a0, a1;
	char c0;
	
	if (d < 0.0) {
		c0 = 'S';
		d = -d;
	}
	else {
		c0 = 'N';
	}
	a0 = (int)(floor(d));
	a1 = (int)((d - (double)(a0))*60 + 0.5);
	
	return [NSString stringWithFormat:@"%d%c%02d", a0, c0, a1];
}

-(NSString *)GetTextLongitude:(double)d
{
	int a0, a1;
	char c0;
	
	c0 = d < 0.0 ? 'W' : 'E';
	a0 = (int)(fabs(d));
	a1 = (int)((fabs(d) - a0)*60 + 0.5);
	
	return [NSString stringWithFormat:@"%d%c%02d", a0, c0, a1];
}

-(NSString *)GetTextTimeZone:(double)d
{
	int a4, a5;
	int sig;
	if (d < 0.0)
	{
		sig = -1;
		d = -d;
	}
	else
	{
		sig = 1;
	}
	
	a4 = (int)d;
	a5 = (int)((d - a4)*60 + 0.5);
	
	return [NSString stringWithFormat:@"%s%d:%02d", (sig < 0 ? "-" : "+"), a4, a5];
}

/*-(GcDayFestival *)GetSpecFestivalRecord:(int)i forClass:(int)inClass
{
	GcDayFestival * p = [[[GcDayFestival alloc] init] autorelease];
	switch(i)
	{
		case SPEC_JANMASTAMI:
			p.name = [self string:741];
			p.group = inClass;
			p.fast = 5;
			p.fastSubj = @"Sri Krsna";
			break;
		case SPEC_GAURAPURNIMA:
			p.name = [self string:742];
			p.group = inClass;
			p.fast = 3;
			p.fastSubj = @"Sri Caitanya Mahaprabhu";
			break;
		case SPEC_RETURNRATHA:
			p.name = [self string:743];
			p.group = inClass;
			break;
		case SPEC_HERAPANCAMI:
			p.name = [self string:744];
			p.group = inClass;
			break;
		case SPEC_GUNDICAMARJANA:
			p.name = [self string:745];
			p.group = inClass;
			break;
		case SPEC_GOVARDHANPUJA:
			p.name = [self string:746];
			p.group = inClass;
			break;
		case SPEC_RAMANAVAMI:
			p.name = [self string:747];
			p.group = inClass;
			p.fast = 2;
			p.fastSubj = @"Sri Ramacandra";
			break;
		case SPEC_RATHAYATRA:
			p.name = [self string:748];
			p.group = inClass;
			break;
		case SPEC_NANDAUTSAVA:
			p.name = [self string:749];
			p.group = inClass;
			break;
		case SPEC_PRABHAPP:
			p.name = [self string:759];
			p.group = inClass;
			p.fast = 1;
			p.fastSubj = @"Srila Prabhupada";
			break;
		case SPEC_MISRAFESTIVAL:
			p.name = [self string:750];
			p.group = inClass;
			break;
		default:
			p.name = [self string:64];
			p.group = inClass;
			return nil;
	}
	
	return p;
}*/

-(NSString *)timeToString:(gc_time)time
{
	return [NSString stringWithFormat:@"%02d:%02d:%02d", gc_time_GetHour(time), gc_time_GetMinute(time), gc_time_GetSecond(time)];
}

-(NSString *)daytimeToString:(gc_daytime)time
{
	return [NSString stringWithFormat:@"%02d:%02d:%02d", time.hour, time.minute, time.sec];
}

-(NSString *)fullDateString:(gc_time)time withHours:(double)shour
{
	double th1, tm1;
	double h1, m1, m60, s1;
	m1 = modf(shour, &h1);
	m60 = m1 * 60;
	s1 = modf(m60, &m1) * 60;
	tm1 = modf(fabs(time.tzone), &th1);
	return [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d %c%02d%02d"
			, time.year, time.month, time.day
			, (int)h1, (int)m1, (int)s1
			, (time.tzone < 0.0 ? '-' : '+')
			, (int)th1, (int)tm1];
}

-(NSString *)hoursToString:(double)shour
{
	double h1, m1;
	m1 = modf(shour, &h1);
	return [NSString stringWithFormat:@"%02d:%02d", (int)(h1), (int)(m1*60)];
}

-(NSString *)timeShortToString:(gc_time)time
{
	return [NSString stringWithFormat:@"%02d:%02d", gc_time_GetHour(time), gc_time_GetMinuteRound(time)];
}

-(NSString *)dateToString:(gc_time)time
{
	return [NSString stringWithFormat:@"%d %@ %d", time.day, [self GetMonthAbr:time.month], time.year];
}

-(NSString *)dateShortToString:(gc_time)time
{
	return [NSString stringWithFormat:@"%d %@", time.day, [self GetMonthAbr:time.month]];
}

-(void)appendRtfHeader:(NSMutableString *)m_text
{
	[m_text appendFormat:@"%s", "{\\rtf1\\ansi\\ansicpg1252\\deff2\\deflang1033{\\fonttbl{\\f0\\fswiss\\fcharset0 Lucida Console;}"
			"{\\f1\\fswiss\\fcharset0 Arial;}{\\f2\\froman\\fprq2\\fcharset0 Book Antiqua;}}"
			"{\\colortbl ;"];
	[self appendColorTable:m_text];
	[m_text appendFormat:@"}{\\*\\generator GCAL;}\\viewkind4\\uc1\\pard\\f0\\fs20 "];
}

-(void)appendColorTable:(NSMutableString *)str
{
	char * p = "\\red0\\green0\\blue0;" //0
		"\\red16\\green16\\blue16;" //1
		"\\red32\\green32\\blue32;" //2
		"\\red48\\green48\\blue48;" //3
		"\\red64\\green64\\blue64;" //4
		"\\red80\\green80\\blue80;" //5
		"\\red96\\green96\\blue96;" //6
		"\\red112\\green112\\blue112;" //7
		"\\red128\\green128\\blue128;" // 8 
		"\\red143\\green143\\blue143;" // 9 
		"\\red159\\green159\\blue159;" // 10 
		"\\red175\\green175\\blue175;" // 11 
		"\\red191\\green191\\blue191;" // 12 
		"\\red207\\green207\\blue207;" // 13 
		"\\red223\\green223\\blue223;" // 14 
		"\\red239\\green239\\blue239;" // 15 
		"\\red255\\green255\\blue255;" // 16 
		"\\red0\\green0\\blue0;" //17
		"\\red31\\green0\\blue0;" //18
		"\\red63\\green0\\blue0;" //19
		"\\red95\\green0\\blue0;" //20
		"\\red127\\green0\\blue0;" //21
		"\\red159\\green0\\blue0;" //22
		"\\red191\\green0\\blue0;" //23
		"\\red223\\green0\\blue0;" //24
		"\\red255\\green0\\blue0;" // 25 
		"\\red255\\green31\\blue31;" // 26 
		"\\red255\\green63\\blue63;" // 27 
		"\\red255\\green95\\blue95;" // 28 
		"\\red255\\green127\\blue127;" // 29 
		"\\red255\\green159\\blue159;" // 30 
		"\\red255\\green191\\blue191;" // 31 
		"\\red255\\green223\\blue223;" // 32 
		"\\red255\\green255\\blue255;" // 33 
		"\\red0\\green0\\blue0;" //34
		"\\red31\\green16\\blue0;" //35
		"\\red63\\green32\\blue0;" //36
		"\\red95\\green48\\blue0;" //37
		"\\red127\\green64\\blue0;" //38
		"\\red159\\green80\\blue0;" //39
		"\\red191\\green96\\blue0;" //40
		"\\red223\\green112\\blue0;" //41
		"\\red255\\green128\\blue0;" // 42 
		"\\red255\\green143\\blue31;" // 43 
		"\\red255\\green159\\blue63;" // 44 
		"\\red255\\green175\\blue95;" // 45 
		"\\red255\\green191\\blue127;" // 46 
		"\\red255\\green207\\blue159;" // 47 
		"\\red255\\green223\\blue191;" // 48 
		"\\red255\\green239\\blue223;" // 49 
		"\\red255\\green255\\blue255;" // 50 
		"\\red0\\green0\\blue0;" //51
		"\\red31\\green31\\blue0;" //52
		"\\red63\\green63\\blue0;" //53
		"\\red95\\green95\\blue0;" //54
		"\\red127\\green127\\blue0;" //55
		"\\red159\\green159\\blue0;" //56
		"\\red191\\green191\\blue0;" //57
		"\\red223\\green223\\blue0;" //58
		"\\red255\\green255\\blue0;" // 59 
		"\\red255\\green255\\blue31;" // 60 
		"\\red255\\green255\\blue63;" // 61 
		"\\red255\\green255\\blue95;" // 62 
		"\\red255\\green255\\blue127;" // 63 
		"\\red255\\green255\\blue159;" // 64 
		"\\red255\\green255\\blue191;" // 65 
		"\\red255\\green255\\blue223;" // 66 
		"\\red255\\green255\\blue255;" // 67 
		"\\red0\\green0\\blue0;" //68
		"\\red16\\green31\\blue0;" //69
		"\\red32\\green63\\blue0;" //70
		"\\red48\\green95\\blue0;" //71
		"\\red64\\green127\\blue0;" //72
		"\\red80\\green159\\blue0;" //73
		"\\red96\\green191\\blue0;" //74
		"\\red112\\green223\\blue0;" //75
		"\\red128\\green255\\blue0;" // 76 
		"\\red143\\green255\\blue31;" // 77 
		"\\red159\\green255\\blue63;" // 78 
		"\\red175\\green255\\blue95;" // 79 
		"\\red191\\green255\\blue127;" // 80 
		"\\red207\\green255\\blue159;" // 81 
		"\\red223\\green255\\blue191;" // 82 
		"\\red239\\green255\\blue223;" // 83 
		"\\red255\\green255\\blue255;" // 84 
		"\\red0\\green0\\blue0;" //85
		"\\red0\\green31\\blue0;" //86
		"\\red0\\green63\\blue0;" //87
		"\\red0\\green95\\blue0;" //88
		"\\red0\\green127\\blue0;" //89
		"\\red0\\green159\\blue0;" //90
		"\\red0\\green191\\blue0;" //91
		"\\red0\\green223\\blue0;" //92
		"\\red0\\green255\\blue0;" // 93 
		"\\red31\\green255\\blue31;" // 94 
		"\\red63\\green255\\blue63;" // 95 
		"\\red95\\green255\\blue95;" // 96 
		"\\red127\\green255\\blue127;" // 97 
		"\\red159\\green255\\blue159;" // 98 
		"\\red191\\green255\\blue191;" // 99 
		"\\red223\\green255\\blue223;" // 100 
		"\\red255\\green255\\blue255;" // 101 
		"\\red0\\green0\\blue0;" //102
		"\\red0\\green31\\blue16;" //103
		"\\red0\\green63\\blue32;" //104
		"\\red0\\green95\\blue48;" //105
		"\\red0\\green127\\blue64;" //106
		"\\red0\\green159\\blue80;" //107
		"\\red0\\green191\\blue96;" //108
		"\\red0\\green223\\blue112;" //109
		"\\red0\\green255\\blue128;" // 110 
		"\\red31\\green255\\blue143;" // 111 
		"\\red63\\green255\\blue159;" // 112 
		"\\red95\\green255\\blue175;" // 113 
		"\\red127\\green255\\blue191;" // 114 
		"\\red159\\green255\\blue207;" // 115 
		"\\red191\\green255\\blue223;" // 116 
		"\\red223\\green255\\blue239;" // 117 
		"\\red255\\green255\\blue255;" // 118 
		"\\red0\\green0\\blue0;" //119
		"\\red0\\green31\\blue31;" //120
		"\\red0\\green63\\blue63;" //121
		"\\red0\\green95\\blue95;" //122
		"\\red0\\green127\\blue127;" //123
		"\\red0\\green159\\blue159;" //124
		"\\red0\\green191\\blue191;" //125
		"\\red0\\green223\\blue223;" //126
		"\\red0\\green255\\blue255;" // 127 
		"\\red31\\green255\\blue255;" // 128 
		"\\red63\\green255\\blue255;" // 129 
		"\\red95\\green255\\blue255;" // 130 
		"\\red127\\green255\\blue255;" // 131 
		"\\red159\\green255\\blue255;" // 132 
		"\\red191\\green255\\blue255;" // 133 
		"\\red223\\green255\\blue255;" // 134 
		"\\red255\\green255\\blue255;" // 135 
		"\\red0\\green0\\blue0;" //136
		"\\red0\\green16\\blue31;" //137
		"\\red0\\green32\\blue63;" //138
		"\\red0\\green48\\blue95;" //139
		"\\red0\\green64\\blue127;" //140
		"\\red0\\green80\\blue159;" //141
		"\\red0\\green96\\blue191;" //142
		"\\red0\\green112\\blue223;" //143
		"\\red0\\green128\\blue255;" // 144 
		"\\red31\\green143\\blue255;" // 145 
		"\\red63\\green159\\blue255;" // 146 
		"\\red95\\green175\\blue255;" // 147 
		"\\red127\\green191\\blue255;" // 148 
		"\\red159\\green207\\blue255;" // 149 
		"\\red191\\green223\\blue255;" // 150 
		"\\red223\\green239\\blue255;" // 151 
		"\\red255\\green255\\blue255;" // 152 
		"\\red0\\green0\\blue0;" //153
		"\\red0\\green0\\blue31;" //154
		"\\red0\\green0\\blue63;" //155
		"\\red0\\green0\\blue95;" //156
		"\\red0\\green0\\blue127;" //157
		"\\red0\\green0\\blue159;" //158
		"\\red0\\green0\\blue191;" //159
		"\\red0\\green0\\blue223;" //160
		"\\red0\\green0\\blue255;" // 161 
		"\\red31\\green31\\blue255;" // 162 
		"\\red63\\green63\\blue255;" // 163 
		"\\red95\\green95\\blue255;" // 164 
		"\\red127\\green127\\blue255;" // 165 
		"\\red159\\green159\\blue255;" // 166 
		"\\red191\\green191\\blue255;" // 167 
		"\\red223\\green223\\blue255;" // 168 
		"\\red255\\green255\\blue255;" // 169 
		"\\red0\\green0\\blue0;" //170
		"\\red16\\green0\\blue31;" //171
		"\\red32\\green0\\blue63;" //172
		"\\red48\\green0\\blue95;" //173
		"\\red64\\green0\\blue127;" //174
		"\\red80\\green0\\blue159;" //175
		"\\red96\\green0\\blue191;" //176
		"\\red112\\green0\\blue223;" //177
		"\\red128\\green0\\blue255;" // 178 
		"\\red143\\green31\\blue255;" // 179 
		"\\red159\\green63\\blue255;" // 180 
		"\\red175\\green95\\blue255;" // 181 
		"\\red191\\green127\\blue255;" // 182 
		"\\red207\\green159\\blue255;" // 183 
		"\\red223\\green191\\blue255;" // 184 
		"\\red239\\green223\\blue255;" // 185 
		"\\red255\\green255\\blue255;" // 186 
		"\\red0\\green0\\blue0;" //187
		"\\red31\\green0\\blue31;" //188
		"\\red63\\green0\\blue63;" //189
		"\\red95\\green0\\blue95;" //190
		"\\red127\\green0\\blue127;" //191
		"\\red159\\green0\\blue159;" //192
		"\\red191\\green0\\blue191;" //193
		"\\red223\\green0\\blue223;" //194
		"\\red255\\green0\\blue255;" // 195 
		"\\red255\\green31\\blue255;" // 196 
		"\\red255\\green63\\blue255;" // 197 
		"\\red255\\green95\\blue255;" // 198 
		"\\red255\\green127\\blue255;" // 199 
		"\\red255\\green159\\blue255;" // 200 
		"\\red255\\green191\\blue255;" // 201 
		"\\red255\\green223\\blue255;" // 202 
		"\\red255\\green255\\blue255;" // 203 
		"\\red0\\green0\\blue0;" //204
		"\\red31\\green0\\blue16;" //205
		"\\red63\\green0\\blue32;" //206
		"\\red95\\green0\\blue48;" //207
		"\\red127\\green0\\blue64;" //208
		"\\red159\\green0\\blue80;" //209
		"\\red191\\green0\\blue96;" //210
		"\\red223\\green0\\blue112;" //211
		"\\red255\\green0\\blue128;" // 212 
		"\\red255\\green31\\blue143;" // 213 
		"\\red255\\green63\\blue159;" // 214 
		"\\red255\\green95\\blue175;" // 215 
		"\\red255\\green127\\blue191;" // 216 
		"\\red255\\green159\\blue207;" // 217 
		"\\red255\\green191\\blue223;" // 218 
		"\\red255\\green223\\blue239;" // 219 
		"\\red255\\green255\\blue255;" // 220 
	;

	[str appendFormat:@"%s", p];
}

-(void)addNoteRtf:(NSMutableString *)str display:(GCDisplaySettings *)disp
{
	[str appendFormat:@"\\par\\par{\\fs16\\cf10\n"];
	[str appendFormat:@"----------------------------------------------------------------------------------"];
	[str appendFormat:@"\\par {\\b Notes:}\\par\\pard\n\n"];
	[str appendFormat:@"\\tab DST - Time is in \'Daylight Saving Time\'\\par\n\\tab LT  - Time is in \'Local Time\'\\par\n"];

	if (disp.sun_long || disp.moon_long || disp.ayanamsa || disp.julian)
	{
		[str appendFormat:@"\\tab (*) - value at the moment of sunrise\\par\n"];
	}

	// last line
	[str appendFormat:@"\\par\n\\tab Generated by "];
	[str appendFormat:@"%@", [self string:131]];
	[str appendFormat:@"}\n"];

}

-(void)addHtmlStylesDef:(NSMutableString *)xml display:(GCDisplaySettings *)disp
{
	[xml appendFormat:@"<!--\nbody {\n"];
	[xml appendFormat:@"  font-family:Verdana;\n"];
	[xml appendFormat:@"  font-size:%@;\n  color:%@;\n}\n\n", disp.bodyTextSize, disp.bodyTextColor];
	[xml appendFormat:@".SectionHead {\ntext-align:center;}\n"];
	[xml appendFormat:@".SectionHead1 {\nfont-size:%@;}\n", disp.h1textSize];
	[xml appendFormat:@".SectionHead2 {\nfont-size:%@;}\n", disp.h3textSize];
	[xml appendFormat:@".SankInfo {\ncolor:%@;}\n", disp.specialTextColor];
	[xml appendFormat:@".GaurHead {\nfont-weight:bold;font-size:%@;color:%@;}\n"
	 , disp.h1textSize, disp.h2color];
	[xml appendFormat:@".GaurSubhead {\nfont-size:%@;color:%@;}"
	 , disp.h2textSize, disp.h2color];
	[xml appendFormat:@"td.hed {\n"];
	[xml appendFormat:@"  font-family:Verdana;\n"];
	[xml appendFormat:@"  font-size:9pt;\n"];
	[xml appendFormat:@"  font-weight:bold;\n"];
	[xml appendFormat:@"  background:#999999;\n"];
	[xml appendFormat:@"  color:white;\n"];
	[xml appendFormat:@"  text-align:center;\n"];
	[xml appendFormat:@"  vertical-align:center;\n  padding-left:5pt;\n  padding-right:5pt;\n"];
	[xml appendFormat:@"  padding-top:3pt;\n  padding-bottom:3pt;\n}\n"];
	[xml appendFormat:@"td.hed2 {\n"];
	[xml appendFormat:@"  font-family:Verdana;\n"];
	[xml appendFormat:@"  font-size:9pt;\n"];
	[xml appendFormat:@"  background:#777777;\n"];
	[xml appendFormat:@"  color:white;\n"];
	[xml appendFormat:@"  text-align:center;\n"];
	[xml appendFormat:@"  vertical-align:center;\n  padding-left:2pt;\n  padding-right:2pt;\n"];
	[xml appendFormat:@"  padding-top:3pt;\n  padding-bottom:3pt;\n}\n"];
	[xml appendFormat:@"-->\n"];
}

@end
