//
//  GcEvents.m
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "GcEvents.h"
#import "GcDayFestival.h"
#import "BalaCalAppDelegate.h"

@implementation GcEvents

void customAddEvent(NSMutableArray * arr, int inClass, 
					int inMasa, int inTithi, int inVisible, 
					const char *pszFastSubject, const char *pszText, 
					int inFastType, int inUsed)
{
	GcDayFestival * pce = [[GcDayFestival alloc] init];
	
	if (pce)
	{
		pce.group = inClass;
		pce.masa = inMasa;
		pce.tithi = inTithi;
		pce.visible = inVisible;
		pce.fastSubj = [NSString stringWithFormat:@"%s", pszFastSubject];
		pce.name = [NSString stringWithFormat:@"%s", pszText];
		pce.fast = inFastType;
		pce.used = inUsed;
		
		[arr addObject:pce];
	}
}


+(NSMutableArray *)defaultEvents
{
    BalaCalAppDelegate * delegate = (BalaCalAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.defaultEvents != nil)
        return delegate.defaultEvents;
    
	NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:300];
    delegate.defaultEvents = arr;

    NSLog(@"default events inita");
    
	// initialize array
	customAddEvent(arr, 3,0,6,1,"","Sri Abhirama Thakura -- Disappearance",0,1);
	customAddEvent(arr, 3,0,9,1,"","Srila Vrndavana Dasa Thakura -- Disappearance",0,1);
	customAddEvent(arr, 3,0,14,1,"","Sri Gadadhara Pandita -- Appearance",0,1);
	customAddEvent(arr, 1,0,17,1,"","Aksaya Trtiya. Candana Yatra starts. (Continues for 21 days)",0,1);
	customAddEvent(arr, 5,0,21,1,"","Jahnu Saptami",0,1);
	customAddEvent(arr, 1,0,23,1,"","Srimati Sita Devi (consort of Lord Sri Rama) -- Appearance",0,1);
	customAddEvent(arr, 3,0,23,1,"","Sri Madhu Pandita -- Disappearance",0,1);
	customAddEvent(arr, 3,0,23,1,"","Srimati Jahnava Devi -- Appearance",0,1);
	customAddEvent(arr, 1,0,26,1,"","Rukmini Dvadasi",0,1);
	customAddEvent(arr, 4,0,27,1,"","Sri Jayananda Prabhu -- Disappearance",0,1);
	customAddEvent(arr, 0,0,28,1,"Lord Nrsimhadeva","Nrsimha Caturdasi: Appearance of Lord Nrsimhadeva",4,1);
	customAddEvent(arr, 1,0,29,1,"","Krsna Phula Dola, Salila Vihara",0,1);
	customAddEvent(arr, 3,0,29,1,"","Sri Paramesvari Dasa Thakura -- Disappearance",0,1);
	customAddEvent(arr, 1,0,29,1,"","Sri Sri Radha-Ramana Devaji -- Appearance",0,1);
	customAddEvent(arr, 3,0,29,1,"","Sri Madhavendra Puri -- Appearance",0,1);
	customAddEvent(arr, 3,0,29,1,"","Sri Srinivasa Acarya -- Appearance",0,1);
	customAddEvent(arr, 3,1,4,1,"","Sri Ramananda Raya -- Disappearance",0,1);
	customAddEvent(arr, 3,1,11,1,"","Srila Vrndavana Dasa Thakura -- Appearance",0,1);
	customAddEvent(arr, 3,1,24,1,"","Sri Baladeva Vidyabhusana -- Disappearance",0,1);
	customAddEvent(arr, 1,1,24,1,"","Ganga Puja",0,1);
	customAddEvent(arr, 3,1,24,1,"","Srimati Gangamata Gosvamini -- Appearance",0,1);
	customAddEvent(arr, 1,1,27,1,"","Panihati Cida Dahi Utsava",0,1);
	customAddEvent(arr, 1,1,29,1,"","Snana Yatra",0,1);
	customAddEvent(arr, 3,1,29,1,"","Sri Mukunda Datta -- Disappearance",0,1);
	customAddEvent(arr, 3,1,29,1,"","Sri Sridhara Pandita -- Disappearance",0,1);
	customAddEvent(arr, 3,2,0,1,"","Sri Syamananda Prabhu -- Disappearance",0,1);
	customAddEvent(arr, 3,2,4,1,"","Sri Vakresvara Pandita -- Appearance",0,1);
	customAddEvent(arr, 3,2,9,1,"","Sri Srivasa Pandita -- Disappearance",0,1);
	customAddEvent(arr, 3,2,14,1,"","Sri Gadadhara Pandita -- Disappearance",0,1);
	customAddEvent(arr, 2,2,14,1,"Bhaktivinoda Thakura","Srila Bhaktivinoda Thakura -- Disappearance",1,1);
	customAddEvent(arr, 3,2,16,1,"","Sri Svarupa Damodara Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,2,16,1,"","Sri Sivananda Sena -- Disappearance",0,1);
	customAddEvent(arr, 3,2,20,1,"","Sri Vakresvara Pandita -- Disappearance",0,1);
	customAddEvent(arr, 1,2,29,1,"","Guru (Vyasa) Purnima",0,1);
	customAddEvent(arr, 3,2,29,1,"","Srila Sanatana Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,3,4,1,"","Srila Gopala Bhatta Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,3,7,1,"","Srila Lokanatha Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 4,3,8,1,"","The incorporation of ISKCON in New York",0,1);
	customAddEvent(arr, 3,3,18,1,"","Sri Raghunandana Thakura -- Disappearance",0,1);
	customAddEvent(arr, 2,3,18,1,"","Sri Vamsidasa Babaji -- Disappearance",0,1);
	customAddEvent(arr, 1,3,25,1,"","Radha Govinda Jhulana Yatra begins",0,1);
	customAddEvent(arr, 3,3,26,1,"","Srila Rupa Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,3,26,1,"","Sri Gauridasa Pandita -- Disappearance",0,1);
	customAddEvent(arr, 1,3,29,1,"","Jhulana Yatra ends",0,1);
	customAddEvent(arr, 0,3,29,1,"Lord Balarama","Lord Balarama -- Appearance",2,1);
	customAddEvent(arr, 4,4,0,1,"","Srila Prabhupada's departure for the USA",0,1);
	customAddEvent(arr, 3,4,19,1,"","Srimati Sita Thakurani (Sri Advaita's consort) -- Appearance",0,1);
	customAddEvent(arr, 1,4,20,1,"","Lalita sasti",0,1);
	customAddEvent(arr, 0,4,22,1,"Srimati Radharani","Radhastami: Appearance of Srimati Radharani",1,1);
	customAddEvent(arr, 0,4,26,1,"Vamanadeva","Sri Vamana Dvadasi: Appearance of Lord Vamanadeva",2,1);
	customAddEvent(arr, 3,4,26,1,"","Srila Jiva Gosvami -- Appearance",0,1);
	customAddEvent(arr, 2,4,27,1,"Bhaktivinoda Thakura","Srila Bhaktivinoda Thakura -- Appearance",1,1);
	customAddEvent(arr, 1,4,28,1,"","Ananta Caturdasi Vrata",0,1);
	customAddEvent(arr, 3,4,28,1,"","Srila Haridasa Thakura -- Disappearance",0,1);
	customAddEvent(arr, 1,4,29,1,"","Sri Visvarupa Mahotsava",0,1);
	customAddEvent(arr, 4,4,29,1,"","Acceptance of sannyasa by Srila Prabhupada",0,1);
	customAddEvent(arr, 4,5,6,1,"","Srila Prabhupada's arrival in the USA",0,1);
	customAddEvent(arr, 5,5,21,1,"","Durga Puja",0,1);
	customAddEvent(arr, 1,5,24,1,"","Ramacandra Vijayotsava",0,1);
	customAddEvent(arr, 2,5,24,1,"","Sri Madhvacarya -- Appearance",0,1);
	customAddEvent(arr, 3,5,26,1,"","Srila Raghunatha Dasa Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,5,26,1,"","Srila Raghunatha Bhatta Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,5,26,1,"","Srila Krsnadasa Kaviraja Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 1,5,29,1,"","Sri Krsna Saradiya Rasayatra",0,1);
	customAddEvent(arr, 3,5,29,1,"","Sri Murari Gupta -- Disappearance",0,1);
	customAddEvent(arr, 5,5,29,1,"","Laksmi Puja",0,1);
	customAddEvent(arr, 3,6,4,1,"","Srila Narottama Dasa Thakura -- Disappearance",0,1);
	customAddEvent(arr, 1,6,7,1,"","Appearance of Radha Kunda, snana dana",0,1);
	customAddEvent(arr, 1,6,7,1,"","Bahulastami",0,1);
	customAddEvent(arr, 3,6,8,1,"","Sri Virabhadra -- Appearance",0,1);
	customAddEvent(arr, 1,6,14,1,"","Dipa dana, Dipavali, (Kali Puja)",0,1);
	customAddEvent(arr, 1,6,15,1,"","Bali Daityaraja Puja",0,1);
	customAddEvent(arr, 3,6,15,1,"","Sri Rasikananda -- Appearance",0,1);
	customAddEvent(arr, 3,6,16,1,"","Sri Vasudeva Ghosh -- Disappearance",0,1);
	customAddEvent(arr, 2,6,18,1,"Srila Prabhupada","Srila Prabhupada -- Disappearance",1,1);
	customAddEvent(arr, 1,6,22,1,"","Gopastami, Gosthastami",0,1);
	customAddEvent(arr, 3,6,22,1,"","Sri Gadadhara Dasa Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,6,22,1,"","Sri Dhananjaya Pandita -- Disappearance",0,1);
	customAddEvent(arr, 3,6,22,1,"","Sri Srinivasa Acarya -- Disappearance",0,1);
	customAddEvent(arr, 5,6,23,1,"","Jagaddhatri Puja",0,1);
	customAddEvent(arr, 2,6,25,1,"Gaura Kisora Dasa Babaji","Srila Gaura Kisora Dasa Babaji -- Disappearance",1,1);
	customAddEvent(arr, 3,6,28,1,"","Sri Bhugarbha Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,6,28,1,"","Sri Kasisvara Pandita -- Disappearance",0,1);
	customAddEvent(arr, 1,6,29,1,"","Sri Krsna Rasayatra",0,1);
	customAddEvent(arr, 1,6,29,1,"","Tulasi-Saligrama Vivaha (marriage)",0,1);
	customAddEvent(arr, 3,6,29,1,"","Sri Nimbarkacarya -- Appearance",0,1);
	customAddEvent(arr, 1,7,0,1,"","Katyayani vrata begins",0,1);
	customAddEvent(arr, 3,7,10,1,"","Sri Narahari Sarakara Thakura -- Disappearance",0,1);
	customAddEvent(arr, 3,7,11,1,"","Sri Kaliya Krsnadasa -- Disappearance",0,1);
	customAddEvent(arr, 3,7,12,1,"","Sri Saranga Thakura -- Disappearance",0,1);
	customAddEvent(arr, 1,7,20,1,"","Odana sasthi",0,1);
	customAddEvent(arr, 1,7,25,1,"","Advent of Srimad Bhagavad-gita",0,1);
	customAddEvent(arr, 1,7,29,1,"","Katyayani vrata ends",0,1);
	customAddEvent(arr, 2,8,3,1,"Bhaktisiddhanta Sarasvati","Srila Bhaktisiddhanta Sarasvati Thakura -- Disappearance",1,1);
	customAddEvent(arr, 3,8,10,1,"","Sri Devananda Pandita -- Disappearance",0,1);
	customAddEvent(arr, 3,8,12,1,"","Sri Mahesa Pandita -- Disappearance",0,1);
	customAddEvent(arr, 3,8,12,1,"","Sri Uddharana Datta Thakura -- Disappearance",0,1);
	customAddEvent(arr, 3,8,15,1,"","Sri Locana Dasa Thakura -- Appearance",0,1);
	customAddEvent(arr, 3,8,17,1,"","Srila Jiva Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,8,17,1,"","Sri Jagadisa Pandita -- Disappearance",0,1);
	customAddEvent(arr, 3,8,26,1,"","Sri Jagadisa Pandita -- Appearance",0,1);
	customAddEvent(arr, 1,8,29,1,"","Sri Krsna Pusya Abhiseka",0,1);
	customAddEvent(arr, 3,9,4,1,"","Sri Ramacandra Kaviraja -- Disappearance",0,1);
	customAddEvent(arr, 3,9,4,1,"","Srila Gopala Bhatta Gosvami -- Appearance",0,1);
	customAddEvent(arr, 3,9,5,1,"","Sri Jayadeva Gosvami -- Disappearance",0,1);
	customAddEvent(arr, 3,9,6,1,"","Sri Locana Dasa Thakura -- Disappearance",0,1);
	customAddEvent(arr, 1,9,19,1,"","Vasanta Pancami",0,1);
	customAddEvent(arr, 3,9,19,1,"","Srimati Visnupriya Devi -- Appearance",0,1);
	customAddEvent(arr, 5,9,19,1,"","Sarasvati Puja",0,1);
	customAddEvent(arr, 3,9,19,1,"","Srila Visvanatha Cakravarti Thakura -- Disappearance",0,1);
	customAddEvent(arr, 3,9,19,1,"","Sri Pundarika Vidyanidhi -- Appearance",0,1);
	customAddEvent(arr, 3,9,19,1,"","Sri Raghunandana Thakura -- Appearance",0,1);
	customAddEvent(arr, 3,9,19,1,"","Srila Raghunatha Dasa Gosvami -- Appearance",0,1);
	customAddEvent(arr, 0,9,21,1,"Advaita Acarya","Sri Advaita Acarya -- Appearance",2,1);
	customAddEvent(arr, 1,9,22,1,"","Bhismastami",0,1);
	customAddEvent(arr, 3,9,23,1,"","Sri Madhvacarya -- Disappearance",0,1);
	customAddEvent(arr, 3,9,24,1,"","Sri Ramanujacarya -- Disappearance",0,1);
	customAddEvent(arr, 0,9,26,1,"Varahadeva","Varaha Dvadasi: Appearance of Lord Varahadeva",2,1);
	customAddEvent(arr, 0,9,27,1,"Sri Nityananda","Nityananda Trayodasi: Appearance of Sri Nityananda Prabhu",2,1);
	customAddEvent(arr, 1,9,29,1,"","Sri Krsna Madhura Utsava",0,1);
	customAddEvent(arr, 3,9,29,1,"","Srila Narottama Dasa Thakura -- Appearance",0,1);
	customAddEvent(arr, 3,10,4,1,"","Sri Purusottama Das Thakura -- Disappearance",0,1);
	customAddEvent(arr, 2,10,4,1,"Bhaktisiddhanta Sarasvati","Srila Bhaktisiddhanta Sarasvati Thakura -- Appearance",1,1);
	customAddEvent(arr, 3,10,11,1,"","Sri Isvara Puri -- Disappearance",0,1);
	customAddEvent(arr, 1,10,13,1,"","Siva Ratri",0,1);
	customAddEvent(arr, 2,10,15,1,"","Srila Jagannatha Dasa Babaji -- Disappearance",0,1);
	customAddEvent(arr, 3,10,15,1,"","Sri Rasikananda -- Disappearance",0,1);
	customAddEvent(arr, 3,10,18,1,"","Sri Purusottama Dasa Thakura -- Appearance",0,1);
	customAddEvent(arr, 3,10,26,1,"","Sri Madhavendra Puri -- Disappearance",0,1);
	customAddEvent(arr, 3,11,7,1,"","Sri Srivasa Pandita -- Appearance",0,1);
	customAddEvent(arr, 3,11,11,1,"","Sri Govinda Ghosh -- Disappearance",0,1);
	customAddEvent(arr, 3,11,19,1,"","Sri Ramanujacarya -- Appearance",0,1);
	customAddEvent(arr, 1,11,26,1,"","Damanakaropana Dvadasi",0,1);
	customAddEvent(arr, 1,11,29,1,"","Sri Balarama Rasayatra",0,1);
	customAddEvent(arr, 1,11,29,1,"","Sri Krsna Vasanta Rasa",0,1);
	customAddEvent(arr, 3,11,29,1,"","Sri Vamsivadana Thakura -- Appearance",0,1);
	customAddEvent(arr, 3,11,29,1,"","Sri Syamananda Prabhu -- Appearance",0,1);

	return arr;
}


@end
