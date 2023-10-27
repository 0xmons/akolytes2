// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import {StringLib} from "./libs/StringLib.sol";

contract Markov {
    using StringLib for string;
    using StringLib for StringLib.slice;

    uint256 constant POSITION = 32;
    uint256 constant NUM_WORDS = 256;
    uint256 constant BYTE = 8;

    string constant INCANTATION =
        "Appears ,creator ,up ,World ,back ,unknown ,stars ,man ,old ,eye ,resides ,plane ,come ,earth. ,Many ,though ,even ,primordial ,wears ,light. ,female ,When ,so ,bound ,destroy ,red ,beings ,ability ,He ,or ,ancient ,Gods ,physical ,Pitch ,depths ,before ,most ,appear ,being ,eyes ,her ,creature ,described ,mass ,their ,such ,his ,often ,entities ,across ,blue ,Unnamed ,wings. ,they ,are ,into ,each ,living ,Her ,tentacles ,upon ,which ,Abyss ,arms ,first ,great ,also ,Rhot. ,Gulf ,dwell ,Old ,One ,deep ,colossal ,life ,human ,from ,ever ,every ,new ,few ,not ,known ,she ,glowing ,covered ,but ,Its ,always ,many ,no ,long ,than ,green ,Gigantic ,powerful ,had ,once ,order ,may ,was ,killed ,head ,small ,for ,body ,servant ,takes ,monstrous ,She ,power ,dark ,yet ,world ,has ,Time ,dead ,Said ,blood ,mysterious ,its ,much ,any ,between ,void ,through ,other ,name ,humanoid ,made ,six ,eye. ,seen ,large ,being ,pure ,fire ,eyes. ,time ,some ,thing ,own ,mouth ,huge ,been ,after ,three ,Gods ,were ,where ,out ,realm ,in ,Gods. ,His ,bring ,whose ,one ,will ,massive ,he ,over ,single ,have ,who ,those ,A ,only ,death. ,on ,knowledge ,all ,people ,to ,said ,is ,entity ,An ,if ,reality ,more ,head. ,dwells ,flesh ,The ,souls ,creatures ,In ,death ,when ,entity ,gigantic ,appears ,last ,create ,during ,exists ,deity ,universe. ,believed ,manifestation ,true ,since ,him ,things ,four ,depicted ,giant ,end ,white ,within ,like ,god ,death ,face ,long ,figure ,lives ,them. ,gods ,embodiment ,very ,as ,now ,be ,can ,it ,this ,created ,Black ,It ,it. ,shape ,They ,enormous ,an ,with ,them ,form ,a ,and ,immense ,of ,light ,black ,by ,capable ,able ,at ,world. ,the ,state ,that ,force ,two ,center";

    uint256[256] FREQS = [
        69021166917929654183797854193921103065232878953171560433536973939980225734631,
        83551938900651779677463303525828181537469899059062038659726906898293265726202,
        33602410210044699848408855523907164343666390086569970744759959678408117646066,
        113521656115015877866246063734007752797323514378078984352409396086189342784250,
        52674048545630063188930159449964690397975876668873390744100993813484035308282,
        50857701939527211691703723409630594683767797110100284779618299739521340863218,
        24520677724015188453848578823562813257620254248966310266733434035844201249530,
        107164443372574988705736572634652187513870280664441034088516975661512849685756,
        20887984725162921899190627143843411880591293779909378661514244834815793425387,
        38143276454649464856855659090597765106489094151847190781147308124805770575100,
        27699284092063874338001831642962761952859484143098788018123190714065631374572,
        34510583458996214064149858145634275050347619258597902114375649443528841034490,
        24974764347523724032574789218991989525158718944406452704775022259928617037229,
        7719474077367518155389756598474221532355390775530652867526173459873380629242,
        74016119786990352368792433554573061732713247782033882822691710972119555373561,
        18163464978402550138037942675163961011945113163476248494612190072570917348066,
        36781016591731947253488755716014683693052866399706024693695023193850891795708,
        5903126130773584656598107748235394997157199019662929572168915892828479815165,
        12714425498837515419530846868144312107399650694312710260361058293353505553146,
        54490394935207695584827166254557000595238001079872768801895428705846432035570,
        58123087930888129467525581001865516426423156723187281400866539700341506568175,
        89909151643092620440780220706519611136202882313198004563919703127344874847484,
        32694236961124738989174360555904515448610887962172463252308057629033074390517,
        45408662446036499371172169315677407064109436935325213580312367658139194151634,
        33602410220300052110031035257187895502064119638077132514611769598349976206074,
        17709378357537136742219751061440777337259686614877994763672977007313289409523,
        25882937594646521416333646776437537200759147510735070804308489020633073253114,
        26337024218709289006477910714893426850815429630156657903836747915524654693114,
        8173898752083690055222874448099327419571217067792491078839436088864588233209,
        17709634724216218628588686009466128561196949639534811043225997105664652996591,
        14085568176493439321214088482854439612028653490050008572593019558920135047930,
        13622598814998921188547376589654679663762222696654926966090477470917195788528,
        47679095568306681609745097427240864007308952914811691136478133111022809710077,
        14076685358261968858269977799290378929398386047851880698129437505762237283066,
        54490394947894655101565290901464172997499707527687741857145480801065432185594,
        16801267468242384623923179010060336919407674560786341645742818126214572210938,
        13652766785349067499760683102619440166795847247089800735366053285056300645114,
        15893031858851080210581088887113506226233995050450611743615706324740865061104,
        13622598733825032749178704371546914013858704456279410391565031089158670187258,
        11352165721986168125241523005042614304326931335572677733216469772958851856636,
        6882285480143429352401389556329509118442714826077229730434047225025310946037,
        13622785812154273127453551064182000924761240362107143154491598508127568461052,
        21342071349663045009389319593392222916739843493758203532940693083754795556574,
        25882937702499936596521191181982550950592139573449175533618477864543019267316,
        24974979140379148449982592721838309758284501390351927502165645526540485849845,
        29515632944617588066164477806237521182616758353220323847310812335077475548412,
        3645248544907140830757577357425463153459776863827180807074959549481205297394,
        16347160053434399412466513592971328282552032157505028637204374329549503851499,
        27699284095552808474724190016809788608329033561604117729395149345335294098684,
        16347118484579847092558097751326987463333239439605775385264303051200695827194,
        17709607004744051199078189702396274014525929508971628767861767231500222263536,
        113521656115015877866246063734007752797323514378078984352409396086189342784250,
        53128135063519035338485560020824250319382161857509547122460097514687788282096,
        6880476626098931637672854577908894411488859625451748483634938939628116311292,
        2724748399037153382804385987807095211362113534132722156366126963630318222588,
        5449233500681083490529960105835451140306916361320835692651357952401941004030,
        39051449706631495137281278545105251945570848352120209909338155636151154832114,
        11832873679042771815442351909111512635672040209830934492066372814268508863226,
        12260338860452689012986506848100623939849173067596013550820769592080512711161,
        40413709578531531737279914298345169798128754699902980291739145413797902217970,
        17709385283388847466708127542602769054286129243264234488138170527236365155066,
        4569322929905223745481906241894185809536045674367479852311523475798376234176,
        47225008943895337939091270998248324809285586134018298213911557529708334349050,
        40413709576945652778754029358345630620906475922601749999485010449036303462640,
        14077045656494790070032975356579382008530815450264107867603283182323645479674,
        20434258399985086855317790653406922882533288208686921138267387874637380255486,
        27736533385478265830030185970569487417648962183287284737864570795001648970490,
        12714425484918534375763492730836927092031576035856815965103943608748840514290,
        109888963119335369774526189694519504707819837443217192177476244418723260857082,
        27699284101684874774700150223017671686867960585261012461179518196164649875704,
        14076685358262033385004995100772731237603861913101861832790454751423442385658,
        5903126118004366043660945878056706135917000492867242195876569696070010073842,
        9989906495960376352240372576384896261319377119233761287845868673861855018236,
        11352276482326379075415609523791028313837148400414123685304281375870005802228,
        908325685427714860517430565504821132210967698928688058808258521657853015541,
        34510584162672326563154679943359440217345969027991827027753370745013752494842,
        4996844732572020246829668702653269203647615670651104490554231062328820562682,
        34510583458964826872274214614137156353501101346379710888216618383102243089837,
        25882937594223620154045656406569330298422916758650891168210124848727829839100,
        20887985591264424468397728310887696692604592902461121982779558853178345713904,
        31786063713050248051127023182971385936875791735059249441797775146349686881018,
        7265649289178063550833425729590280259774557566844893587648839494894843130610,
        24520760866593849469879973685718904431139242288005812831664011152697925230322,
        4569281413702318488698943279690441489861404184899305582210919176555159682300,
        2730049236491484574412999061487550492728469724933392596332991558408534290415,
        69021166917929653742677606750276715712212459746594894075761143085722930435798,
        14089115756559129896080417147346954061493161622262020311428731250579508032250,
        16347118561759302258958962890822983169304990078008167936134879434345044113913,
        27699651319100896392070981117177371438306085298014689644662380941782783163644,
        20902181861412224828036491499832503693779328228179030315873635768152295340794,
        17709530791507283716129465888823475730389741690060214758095789408323938086124,
        45408662446534977552352075516454873879328060364708433043165789544038655848431,
        18163464985909035482301385583694509775350416905131028111164232814095207430906,
        17709690150483336324243936093042860058657361448051181248063698747095570772208,
        4147122698146002531024617927247401728721166456059848107325232125805132577530,
        11806321524081841931226578427553433589060371172206928619445181204641717875453,
        37689190019644986381664572613810737173757064876495439394383152112417836625903,
        27706380034608545043394036218732092418009203227559266323680900722085095734524,
        69021166917929653742677606781088607043090085323295665030395683169559509136114,
        24066591854222183883678291891967830429906057796966124470339024833625790279920,
        10453090029677134565141421100092531233481036566824844764119725694779945122556,
        45408662446006452780603436531278906109975842485611718077097463920690831489786,
        15902025617659579793858918468984569218076065405748189052330788128719155952378,
        47225008943853213022425956056161689858195121867017850136370276267539442234612,
        18170574291712948766867708451440421107416382945889979994025278849031876573946,
        3632845483679602128746817307881134622315801960327505733458243074555138210556,
        83551938900674400525407183870066511907938349285616837604359641349672517432050,
        29515755309260542630007563644050082627032220825025976500192365569877609348348,
        18617717894373768116548903788363303871605917311587409551278907164004060167934,
        4640426371566466553880669182460721254924000117508705527230738269351047133689,
        18200742583884244295249696141392317869890996021679396637278344626666624187132,
        11352276473445415186663693129998081782732703817530483522101347386707215055610,
        2270959715502676267694214478956985004460190782319863482107982758393974681840,
        14608984521072066903321562797647869918272514689980023016701040497898884365564,
        5477496720459680847836372658794326764256989468165687655793907281081694616830,
        25428850979173106655969180199227807989435859128297989301520995730177209858810,
        1816519719726601793643797455023978338856630913618403237547692857554823215866,
        23612504473509182215203881069599799381643767698875369911264711996740294277625,
        11352297258936964643607127757789425064373153216233713797548653078184267021050,
        11352165909223979689434625941290605844777004123098165725501726574032029020400,
        1843008756483306835773365663164265859829490864850913449649481041213577215165,
        60847607677648539574623607681042706195901902102334705858519530063895138071282,
        24974778202937855405593929238113691119987939235203853344480286121760941866236,
        11806349239647089502806767955265842851498298348265290831742163964699875146490,
        15893031865406047671277934341771882079843942049524375523118595223205451726076,
        1816595935090274196151992966861899311329361578408613504505471617803354831610,
        11806335652365489904530363245476143772596752631636121324772547666832759913210,
        18163467143656296314708680049074529960600603552474111368401091869549292413923,
        9081732624536252647278229276394354857959196338438111295678672373890990206972,
        908443472603312463042289763207582743503335413323902530469798926164612543218,
        17709379003518648874608880472840694312524382923194009367601571326838690609914,
        12714577922340864648957053068763673766815424616773202862315390490458282781675,
        15893115787282477469915604963637987985673675134605687819306773160001476623098,
        23613010276469381964581394169949809474306688875957660057015922407115715444478,
        7786917754160853808842539473185055159788537713029047486973540694515244137212,
        61755780926568685956430721060148806881375434182115231871261416426160044833530,
        34510992258880953277893601411936770513920682099153689498183244271263440827893,
        12714425486784833381034213374988467820651632341816376999691159381095708293882,
        13631502261052097998053144934835403500627596713668693400223244604167792818938,
        6811299368381106965839788573556953754999934570956510285095529425446047511282,
        25882937594223695975772938302560113728243293671653624031738027637188838882556,
        18163464978402540458697834538399945256709036673159838853248505723554188489715,
        46770923131356700127309764752587910880977453269337615906859535349935150528760,
        71291600040233688204418974971058013316285184113987492280076059176010486182128,
        19071804924901931445693583070552977748257018372181996195320884264525922761466,
        16801205106713954628923498598364586218110501196171144080825689677509439453946,
        17709385284023216805656453809558125375113950101620233820947302499511598512890,
        14984858610142403748737159977220226249740521379972432702718703155672040406268,
        2724519746760381364970643098920276768618822887378946414921575074527910230778,
        24066591099449399258050619063690938174552566062121694085219043768552486796026,
        5449039496903971134033911372953233163964479243029743945302431870821718489850,
        14530952140398267862595692250238768512999493252367512464101059180778877549306,
        10670399164545229492857051328147227737576806824215064212305222223271590266,
        12714425620210138062626408081609716720532885746998925619952390614560273529594,
        47679095570632624887511655476530323089900040525544583863829097633116926240743,
        20887984737004153004727277358736362977073797145443332869303753793421616806650,
        57669001306428130485643483561478193575659183342379993785400061215001443950045,
        4132994958807421419644812382613912627845939591742509820775579435389839798514,
        19980019341343436861208543295120224688998364243935345011817569552972135854842,
        18163471908377571166924538332681590618124638420916303026003496683004723655410,
        8203894255946762063105217017560615191348153095929151442827385413568359628028,
        20887984731929339514438848082352066346773649922432841346680941123222049061626,
        34056496835456290889303530639848954725721497102344162704601417987594256379887,
        5452795153551819603398186002846755810661944366877059567286672960959871449852,
        5482810877376151870182622423895251035173716550929187469103282837128230789604,
        72653887628858236789445787991950462747551749589910927602446949800500545322236,
        5910235243198528334509474394533018687879726136973135336192110638595005071301,
        6857453158558089822468454715383853864490441618133445233132561285478067403514,
        12714425486573383498367482109264634031679730673641596327929660535171529765618,
        2736971390444546064787212793390879965765162421235495386460717985001341910270,
        18163464991512475340016532378941726098772853289768215511272941178462781766394,
        10898307637845163524193113108738524689665000227732748717181794813335800839420,
        20888047088383041728495415421278746632829438668160307255044855745284442881790,
        1818169073230126656264239690924198659300926144873495086152604317905040143736,
        18628235859336903424060593900416597693818092830931952149889056718140060007676,
        9991714483059889573490752387041165956912348793478511101521316860178551056301,
        8193078030539734767552902011968604548947077373754187594758793150767038135548,
        13622598744480194221036908388696382770324785520740137795739861132952605424121,
        37689189830192705260417380810297117463728942718373523541892555001424202628862,
        56760828057519089646358526286476631977242316802456016289303110517178180107516,
        7267160092051895016015246428390839976126871509100941736352605148256489110266,
        12714425486784833638249797461134938045931081795385509922732148577211140534255,
        27699360312907915725568409995399126994897144338190051245965416818128663149820,
        42230056077217588257201337970049231310162744713432622350509919246111555123962,
        454121270966293335453311708073786723452240015754714830814217067890782434297,
        19979811477405772904767914230097162623736474060542293040137298915516728670970,
        22250286171943876712661934650257053821542767181329524756158992706327900126460,
        5903126117987846468489371803068038920420139610557155353374859863639727995642,
        27245197467709536340748056280999324749428432149513413349081897512072771728114,
        13211228479029653016868574193252790786312196702142135914516474402762967940862,
        13622599681100446116247862955135782861678840006891483386183182943998228361456,
        49041355442004035188490451242912226296402338799981579001628335894383541155060,
        12714425674352219789516271091538673163022395402360937117835459278024839068924,
        11806252235969911085681630848618299299654285929681938429640946984046655372026,
        20888213381985918030769709425290527402809126304334584420111161675712260930298,
        20887984725162922403328052793722719651496423664829693710678245969865513564922,
        12714426378048952611571858349402767095039172629336648352907782837622563208444,
        7740758115804826865399876394695023224747147365463293020494610008271394372860,
        9535819122965158474360948180510772529535494910289337616623225409953590868730,
        24520677723909462771706434904703104824886470879618037257884433043257573571836,
        14530771982722366307510246642404422856588118797527689636744294751245713472250,
        20887985834856710372025658082935704392001398859172427336786489380232947759866,
        15893031856122046391470894860688969677862629049213799672022580936505198050042,
        20887984941688297717940501440572857851369962170502853492701314586472452127482,
        20433953531200659885137320958989099189045868985094403691046207475129760543474,
        41321882825865779543313621662868387104962146969311194179145974004859523887344,
        21342071349622985038864356423204383016366510790404116246916877621863975283948,
        9090713393420860133648443583679687424454573523357537427917459235933625973498,
        78556986031618657771841657952427750097701885228337469945066483114648901712634,
        17709379274198037639538823767330169773527636957717796858783215718512782671614,
        4564023200786044717586108025411686488507248572636127969161643600285766712058,
        21796158271805446433976420093749366519582063568394990542260550636277514042106,
        13170521491918140613275017140343851460004750833486413459125542980308250066172,
        34056498999758519329167888988868874958482078925161298233986314534474164665082,
        9081912639899659238186056793765104762189043849432828809115333416153997572858,
        59031261183614366608167472316351203520441080838927694067978919982974879334142,
        33148324532883186788679219889729759825169925409119094783710538580899847664884,
        19979811478040124584751821411391791702848718394285599945309377803502235745532,
        34510583466999948231304795722942696761394984793360216381407222109548353219820,
        24974764913682684704728814716412838034431674964402527167228612747616400898810,
        80373381031122393520573642908783863280411406715982748786140743095539684014842,
        43138229325503363644259153516033583174250892535566121446541147870684274948858,
        65650548220758882400980989088622592272732061854338728709957636330976169166,
        4541171115395534714803219499423228894198100883787193559499665946748919807228,
        16363297393436210401797668539043074678237138786276187438093322467510566189820,
        7302801578272224970542614777656898088142077883127611595881741627771317189884,
        6816641508988734531865215503431785662619956720515310015348466156412090762462,
        1816914660429507528983610599895845095673770743894338337831532880887428218108,
        27699554320384517496914254595293727799577883734865227977571799666997881142010,
        113521656115015877866246063734007752797323514378078984352409396086189342784250,
        5913997833091002434825253327776477742431618486305078982199275920750025172985,
        166292651468153201897845569775026342335947715480194425413239388095705842,
        14530771984942263703698685861434851701927080862927487950659094584723540606204,
        24520677720843429619109149767170394911943742102622631630368327423818310214113,
        9989906495960360219841309431949304399441833652490739572519701553183973113598,
        2275824064648282364145190325437458941802703901234590809035927919876749062901,
        3183969867273871138759451283617966329310259774027560326596592758646514030493,
        15893032397415662174024427412456661139711947539094471086532130782987563892221,
        14545003763560157401096629363734735562519823899279974448864251324891674639098,
        3194577310202831356166130753294465205326474554546684153041868931073071933031,
        1819914944610600594912981388562364472003608515944698163790656267887749253710,
        33602410213850809966125180872698190523728094967169019498773750330046060622578,
        455874285132711569863120349867690231275349260166919862718980318321318969667,
        11352373484954524188903669197274897588180423691264612036032899382600902834938,
        19525877286492979372176216096733675728027826970870048901140576718255945741042,
        4995029573598772188550549335211762136675935148083140151987625858270821546750,
        41775969451171645305005954389453430197980471073472727030165531569778850984690,
        45408662450658263695344823275862186038716717231915180824023917300492502360288,
        4995146878546087072906334588348511587293699342313666948167220379858780224250,
        6382045715734614878892366880346999933194467804276757648828185183218038405882,
        457641159263574891769698889520626011272820886415863047961150162990203420994,
        108526703245955179240131236929711478838838583555320264724949003811143806548730,
        3182202561890417235690550819897855015032573618634469062663870059816635179171,
        7719472617407005695409544467961320228066561617349693744948806489273911803132,
        24992800205390148842514658687774922206947163584462119667824284231257329694197,
        109888963119335369774526189694519504707819837443217192177476244418723260857082
    ];

    // Thus spoke 0̵̹̯̮͔̘͆̏̒̀̎̀̍͗̄͆̽̎̎̾̽x̸͕̞͇̱͙̭͆̊̽͐̆̚͝ͅṁ̶̒͑̉̾̏̀͐̈̚
    function speak(uint256 magic, uint256 duration) public view returns (string memory s) {
        magic = uint256(keccak256(abi.encode(magic)));
        // Get first rng word
        StringLib.slice memory strSlice = INCANTATION.toSlice();
        string memory separatorStr = ",";
        StringLib.slice memory separator = separatorStr.toSlice();
        StringLib.slice memory item;
        uint256 wordIndex = magic % NUM_WORDS;
        for (uint256 i; i <= wordIndex;) {
            item = strSlice.split(separator);
            unchecked {
                ++i;
            }
        }
        s = item.toString();
        uint256 freq = FREQS[wordIndex];
        // Get new rng, get new word from old freq, get new freq
        for (uint256 j; j < duration;) {
            magic = uint256(keccak256(abi.encode(magic)));
            wordIndex = uint8(freq >> (BYTE * (magic % POSITION)));
            strSlice = INCANTATION.toSlice();
            for (uint256 i; i <= wordIndex;) {
                item = strSlice.split(separator);
                unchecked {
                    ++i;
                }
            }
            s = string(abi.encodePacked(s, item.toString()));
            freq = FREQS[wordIndex];
            unchecked {
                ++j;
            }
        }
    }
}