class CreateCountries < ActiveRecord::Migration
    def self.up
    ## Create country table
    create_table :countries do |t|
      t.column :iso, :string, :size => 2
      t.column :name, :string, :size => 80
      t.column :printable_name, :string, :size => 80
      t.column :iso3, :string, :size => 3
      t.column :numcode, :integer
    end

    Country.reset_column_information
    Country.create(:iso => 'AF', :name => 'AFGHANISTAN', :printable_name => 'Afghanistan', :iso3 => 'AFG', :numcode => '004') 
    Country.create(:iso => 'AL', :name => 'ALBANIA', :printable_name => 'Albania', :iso3 => 'ALB', :numcode => '008') 
    Country.create(:iso => 'DZ', :name => 'ALGERIA', :printable_name => 'Algeria', :iso3 => 'DZA', :numcode => '012') 
    Country.create(:iso => 'AS', :name => 'AMERICAN SAMOA', :printable_name => 'American Samoa', :iso3 => 'ASM', :numcode => '016') 
    Country.create(:iso => 'AD', :name => 'ANDORRA', :printable_name => 'Andorra', :iso3 => 'AND', :numcode => '020') 
    Country.create(:iso => 'AO', :name => 'ANGOLA', :printable_name => 'Angola', :iso3 => 'AGO', :numcode => '024') 
    Country.create(:iso => 'AI', :name => 'ANGUILLA', :printable_name => 'Anguilla', :iso3 => 'AIA', :numcode => '660') 
    Country.create(:iso => 'AG', :name => 'ANTIGUA AND BARBUDA', :printable_name => 'Antigua and Barbuda', :iso3 => 'ATG', :numcode => '028') 
    Country.create(:iso => 'AR', :name => 'ARGENTINA', :printable_name => 'Argentina', :iso3 => 'ARG', :numcode => '032') 
    Country.create(:iso => 'AM', :name => 'ARMENIA', :printable_name => 'Armenia', :iso3 => 'ARM', :numcode => '051') 
    Country.create(:iso => 'AW', :name => 'ARUBA', :printable_name => 'Aruba', :iso3 => 'ABW', :numcode => '533') 
    Country.create(:iso => 'AU', :name => 'AUSTRALIA', :printable_name => 'Australia', :iso3 => 'AUS', :numcode => '036') 
    Country.create(:iso => 'AT', :name => 'AUSTRIA', :printable_name => 'Austria', :iso3 => 'AUT', :numcode => '040') 
    Country.create(:iso => 'AZ', :name => 'AZERBAIJAN', :printable_name => 'Azerbaijan', :iso3 => 'AZE', :numcode => '031') 
    Country.create(:iso => 'BS', :name => 'BAHAMAS', :printable_name => 'Bahamas', :iso3 => 'BHS', :numcode => '044') 
    Country.create(:iso => 'BH', :name => 'BAHRAIN', :printable_name => 'Bahrain', :iso3 => 'BHR', :numcode => '048') 
    Country.create(:iso => 'BD', :name => 'BANGLADESH', :printable_name => 'Bangladesh', :iso3 => 'BGD', :numcode => '050') 
    Country.create(:iso => 'BB', :name => 'BARBADOS', :printable_name => 'Barbados', :iso3 => 'BRB', :numcode => '052') 
    Country.create(:iso => 'BY', :name => 'BELARUS', :printable_name => 'Belarus', :iso3 => 'BLR', :numcode => '112') 
    Country.create(:iso => 'BE', :name => 'BELGIUM', :printable_name => 'Belgium', :iso3 => 'BEL', :numcode => '056') 
    Country.create(:iso => 'BZ', :name => 'BELIZE', :printable_name => 'Belize', :iso3 => 'BLZ', :numcode => '084') 
    Country.create(:iso => 'BJ', :name => 'BENIN', :printable_name => 'Benin', :iso3 => 'BEN', :numcode => '204') 
    Country.create(:iso => 'BM', :name => 'BERMUDA', :printable_name => 'Bermuda', :iso3 => 'BMU', :numcode => '060') 
    Country.create(:iso => 'BT', :name => 'BHUTAN', :printable_name => 'Bhutan', :iso3 => 'BTN', :numcode => '064') 
    Country.create(:iso => 'BO', :name => 'BOLIVIA', :printable_name => 'Bolivia', :iso3 => 'BOL', :numcode => '068') 
    Country.create(:iso => 'BA', :name => 'BOSNIA AND HERZEGOVINA', :printable_name => 'Bosnia and Herzegovina', :iso3 => 'BIH', :numcode => '070') 
    Country.create(:iso => 'BW', :name => 'BOTSWANA', :printable_name => 'Botswana', :iso3 => 'BWA', :numcode => '072') 
    Country.create(:iso => 'BR', :name => 'BRAZIL', :printable_name => 'Brazil', :iso3 => 'BRA', :numcode => '076') 
    Country.create(:iso => 'BN', :name => 'BRUNEI DARUSSALAM', :printable_name => 'Brunei Darussalam', :iso3 => 'BRN', :numcode => '096') 
    Country.create(:iso => 'BG', :name => 'BULGARIA', :printable_name => 'Bulgaria', :iso3 => 'BGR', :numcode => '100') 
    Country.create(:iso => 'BF', :name => 'BURKINA FASO', :printable_name => 'Burkina Faso', :iso3 => 'BFA', :numcode => '854') 
    Country.create(:iso => 'BI', :name => 'BURUNDI', :printable_name => 'Burundi', :iso3 => 'BDI', :numcode => '108') 
    Country.create(:iso => 'KH', :name => 'CAMBODIA', :printable_name => 'Cambodia', :iso3 => 'KHM', :numcode => '116') 
    Country.create(:iso => 'CM', :name => 'CAMEROON', :printable_name => 'Cameroon', :iso3 => 'CMR', :numcode => '120') 
    Country.create(:iso => 'CA', :name => 'CANADA', :printable_name => 'Canada', :iso3 => 'CAN', :numcode => '124') 
    Country.create(:iso => 'CV', :name => 'CAPE VERDE', :printable_name => 'Cape Verde', :iso3 => 'CPV', :numcode => '132') 
    Country.create(:iso => 'KY', :name => 'CAYMAN ISLANDS', :printable_name => 'Cayman Islands', :iso3 => 'CYM', :numcode => '136') 
    Country.create(:iso => 'CF', :name => 'CENTRAL AFRICAN REPUBLIC', :printable_name => 'Central African Republic', :iso3 => 'CAF', :numcode => '140') 
    Country.create(:iso => 'TD', :name => 'CHAD', :printable_name => 'Chad', :iso3 => 'TCD', :numcode => '148') 
    Country.create(:iso => 'CL', :name => 'CHILE', :printable_name => 'Chile', :iso3 => 'CHL', :numcode => '152') 
    Country.create(:iso => 'CN', :name => 'CHINA', :printable_name => 'China', :iso3 => 'CHN', :numcode => '156') 
    Country.create(:iso => 'CO', :name => 'COLOMBIA', :printable_name => 'Colombia', :iso3 => 'COL', :numcode => '170') 
    Country.create(:iso => 'KM', :name => 'COMOROS', :printable_name => 'Comoros', :iso3 => 'COM', :numcode => '174') 
    Country.create(:iso => 'CG', :name => 'CONGO', :printable_name => 'Congo', :iso3 => 'COG', :numcode => '178') 
    Country.create(:iso => 'CD', :name => 'CONGO, THE DEMOCRATIC REPUBLIC OF THE', :printable_name => 'Congo, the Democratic Republic of the', :iso3 => 'COD', :numcode => '180') 
    Country.create(:iso => 'CK', :name => 'COOK ISLANDS', :printable_name => 'Cook Islands', :iso3 => 'COK', :numcode => '184') 
    Country.create(:iso => 'CR', :name => 'COSTA RICA', :printable_name => 'Costa Rica', :iso3 => 'CRI', :numcode => '188') 
    Country.create(:iso => 'CI', :name => 'COTE D\'IVOIRE', :printable_name => 'Cote D\'Ivoire', :iso3 => 'CIV', :numcode => '384') 
    Country.create(:iso => 'HR', :name => 'CROATIA', :printable_name => 'Croatia', :iso3 => 'HRV', :numcode => '191') 
    Country.create(:iso => 'CU', :name => 'CUBA', :printable_name => 'Cuba', :iso3 => 'CUB', :numcode => '192') 
    Country.create(:iso => 'CY', :name => 'CYPRUS', :printable_name => 'Cyprus', :iso3 => 'CYP', :numcode => '196') 
    Country.create(:iso => 'CZ', :name => 'CZECH REPUBLIC', :printable_name => 'Czech Republic', :iso3 => 'CZE', :numcode => '203') 
    Country.create(:iso => 'DK', :name => 'DENMARK', :printable_name => 'Denmark', :iso3 => 'DNK', :numcode => '208') 
    Country.create(:iso => 'DJ', :name => 'DJIBOUTI', :printable_name => 'Djibouti', :iso3 => 'DJI', :numcode => '262') 
    Country.create(:iso => 'DM', :name => 'DOMINICA', :printable_name => 'Dominica', :iso3 => 'DMA', :numcode => '212') 
    Country.create(:iso => 'DO', :name => 'DOMINICAN REPUBLIC', :printable_name => 'Dominican Republic', :iso3 => 'DOM', :numcode => '214') 
    Country.create(:iso => 'EC', :name => 'ECUADOR', :printable_name => 'Ecuador', :iso3 => 'ECU', :numcode => '218') 
    Country.create(:iso => 'EG', :name => 'EGYPT', :printable_name => 'Egypt', :iso3 => 'EGY', :numcode => '818') 
    Country.create(:iso => 'SV', :name => 'EL SALVADOR', :printable_name => 'El Salvador', :iso3 => 'SLV', :numcode => '222') 
    Country.create(:iso => 'GQ', :name => 'EQUATORIAL GUINEA', :printable_name => 'Equatorial Guinea', :iso3 => 'GNQ', :numcode => '226') 
    Country.create(:iso => 'ER', :name => 'ERITREA', :printable_name => 'Eritrea', :iso3 => 'ERI', :numcode => '232') 
    Country.create(:iso => 'EE', :name => 'ESTONIA', :printable_name => 'Estonia', :iso3 => 'EST', :numcode => '233') 
    Country.create(:iso => 'ET', :name => 'ETHIOPIA', :printable_name => 'Ethiopia', :iso3 => 'ETH', :numcode => '231') 
    Country.create(:iso => 'FK', :name => 'FALKLAND ISLANDS (MALVINAS)', :printable_name => 'Falkland Islands (Malvinas)', :iso3 => 'FLK', :numcode => '238') 
    Country.create(:iso => 'FO', :name => 'FAROE ISLANDS', :printable_name => 'Faroe Islands', :iso3 => 'FRO', :numcode => '234') 
    Country.create(:iso => 'FJ', :name => 'FIJI', :printable_name => 'Fiji', :iso3 => 'FJI', :numcode => '242') 
    Country.create(:iso => 'FI', :name => 'FINLAND', :printable_name => 'Finland', :iso3 => 'FIN', :numcode => '246') 
    Country.create(:iso => 'FR', :name => 'FRANCE', :printable_name => 'France', :iso3 => 'FRA', :numcode => '250') 
    Country.create(:iso => 'GF', :name => 'FRENCH GUIANA', :printable_name => 'French Guiana', :iso3 => 'GUF', :numcode => '254') 
    Country.create(:iso => 'PF', :name => 'FRENCH POLYNESIA', :printable_name => 'French Polynesia', :iso3 => 'PYF', :numcode => '258') 
    Country.create(:iso => 'GA', :name => 'GABON', :printable_name => 'Gabon', :iso3 => 'GAB', :numcode => '266') 
    Country.create(:iso => 'GM', :name => 'GAMBIA', :printable_name => 'Gambia', :iso3 => 'GMB', :numcode => '270') 
    Country.create(:iso => 'GE', :name => 'GEORGIA', :printable_name => 'Georgia', :iso3 => 'GEO', :numcode => '268') 
    Country.create(:iso => 'DE', :name => 'GERMANY', :printable_name => 'Germany', :iso3 => 'DEU', :numcode => '276') 
    Country.create(:iso => 'GH', :name => 'GHANA', :printable_name => 'Ghana', :iso3 => 'GHA', :numcode => '288') 
    Country.create(:iso => 'GI', :name => 'GIBRALTAR', :printable_name => 'Gibraltar', :iso3 => 'GIB', :numcode => '292') 
    Country.create(:iso => 'GR', :name => 'GREECE', :printable_name => 'Greece', :iso3 => 'GRC', :numcode => '300') 
    Country.create(:iso => 'GL', :name => 'GREENLAND', :printable_name => 'Greenland', :iso3 => 'GRL', :numcode => '304') 
    Country.create(:iso => 'GD', :name => 'GRENADA', :printable_name => 'Grenada', :iso3 => 'GRD', :numcode => '308') 
    Country.create(:iso => 'GP', :name => 'GUADELOUPE', :printable_name => 'Guadeloupe', :iso3 => 'GLP', :numcode => '312') 
    Country.create(:iso => 'GU', :name => 'GUAM', :printable_name => 'Guam', :iso3 => 'GUM', :numcode => '316') 
    Country.create(:iso => 'GT', :name => 'GUATEMALA', :printable_name => 'Guatemala', :iso3 => 'GTM', :numcode => '320') 
    Country.create(:iso => 'GN', :name => 'GUINEA', :printable_name => 'Guinea', :iso3 => 'GIN', :numcode => '324') 
    Country.create(:iso => 'GW', :name => 'GUINEA-BISSAU', :printable_name => 'Guinea-Bissau', :iso3 => 'GNB', :numcode => '624') 
    Country.create(:iso => 'GY', :name => 'GUYANA', :printable_name => 'Guyana', :iso3 => 'GUY', :numcode => '328') 
    Country.create(:iso => 'HT', :name => 'HAITI', :printable_name => 'Haiti', :iso3 => 'HTI', :numcode => '332') 
    Country.create(:iso => 'VA', :name => 'HOLY SEE (VATICAN CITY STATE)', :printable_name => 'Holy See (Vatican City State)', :iso3 => 'VAT', :numcode => '336') 
    Country.create(:iso => 'HN', :name => 'HONDURAS', :printable_name => 'Honduras', :iso3 => 'HND', :numcode => '340') 
    Country.create(:iso => 'HK', :name => 'HONG KONG', :printable_name => 'Hong Kong', :iso3 => 'HKG', :numcode => '344') 
    Country.create(:iso => 'HU', :name => 'HUNGARY', :printable_name => 'Hungary', :iso3 => 'HUN', :numcode => '348') 
    Country.create(:iso => 'IS', :name => 'ICELAND', :printable_name => 'Iceland', :iso3 => 'ISL', :numcode => '352') 
    Country.create(:iso => 'IN', :name => 'INDIA', :printable_name => 'India', :iso3 => 'IND', :numcode => '356') 
    Country.create(:iso => 'ID', :name => 'INDONESIA', :printable_name => 'Indonesia', :iso3 => 'IDN', :numcode => '360') 
    Country.create(:iso => 'IR', :name => 'IRAN, ISLAMIC REPUBLIC OF', :printable_name => 'Iran, Islamic Republic of', :iso3 => 'IRN', :numcode => '364') 
    Country.create(:iso => 'IQ', :name => 'IRAQ', :printable_name => 'Iraq', :iso3 => 'IRQ', :numcode => '368') 
    Country.create(:iso => 'IE', :name => 'IRELAND', :printable_name => 'Ireland', :iso3 => 'IRL', :numcode => '372') 
    Country.create(:iso => 'IL', :name => 'ISRAEL', :printable_name => 'Israel', :iso3 => 'ISR', :numcode => '376') 
    Country.create(:iso => 'IT', :name => 'ITALY', :printable_name => 'Italy', :iso3 => 'ITA', :numcode => '380') 
    Country.create(:iso => 'JM', :name => 'JAMAICA', :printable_name => 'Jamaica', :iso3 => 'JAM', :numcode => '388') 
    Country.create(:iso => 'JP', :name => 'JAPAN', :printable_name => 'Japan', :iso3 => 'JPN', :numcode => '392') 
    Country.create(:iso => 'JO', :name => 'JORDAN', :printable_name => 'Jordan', :iso3 => 'JOR', :numcode => '400') 
    Country.create(:iso => 'KZ', :name => 'KAZAKHSTAN', :printable_name => 'Kazakhstan', :iso3 => 'KAZ', :numcode => '398') 
    Country.create(:iso => 'KE', :name => 'KENYA', :printable_name => 'Kenya', :iso3 => 'KEN', :numcode => '404') 
    Country.create(:iso => 'KI', :name => 'KIRIBATI', :printable_name => 'Kiribati', :iso3 => 'KIR', :numcode => '296') 
    Country.create(:iso => 'KP', :name => 'KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF', :printable_name => 'Korea, Democratic People\'s Republic of', :iso3 => 'PRK', :numcode => '408') 
    Country.create(:iso => 'KR', :name => 'KOREA, REPUBLIC OF', :printable_name => 'Korea, Republic of', :iso3 => 'KOR', :numcode => '410') 
    Country.create(:iso => 'KW', :name => 'KUWAIT', :printable_name => 'Kuwait', :iso3 => 'KWT', :numcode => '414') 
    Country.create(:iso => 'KG', :name => 'KYRGYZSTAN', :printable_name => 'Kyrgyzstan', :iso3 => 'KGZ', :numcode => '417') 
    Country.create(:iso => 'LA', :name => 'LAO PEOPLE\'S DEMOCRATIC REPUBLIC', :printable_name => 'Lao People\'s Democratic Republic', :iso3 => 'LAO', :numcode => '418') 
    Country.create(:iso => 'LV', :name => 'LATVIA', :printable_name => 'Latvia', :iso3 => 'LVA', :numcode => '428') 
    Country.create(:iso => 'LB', :name => 'LEBANON', :printable_name => 'Lebanon', :iso3 => 'LBN', :numcode => '422') 
    Country.create(:iso => 'LS', :name => 'LESOTHO', :printable_name => 'Lesotho', :iso3 => 'LSO', :numcode => '426') 
    Country.create(:iso => 'LR', :name => 'LIBERIA', :printable_name => 'Liberia', :iso3 => 'LBR', :numcode => '430') 
    Country.create(:iso => 'LY', :name => 'LIBYAN ARAB JAMAHIRIYA', :printable_name => 'Libyan Arab Jamahiriya', :iso3 => 'LBY', :numcode => '434') 
    Country.create(:iso => 'LI', :name => 'LIECHTENSTEIN', :printable_name => 'Liechtenstein', :iso3 => 'LIE', :numcode => '438') 
    Country.create(:iso => 'LT', :name => 'LITHUANIA', :printable_name => 'Lithuania', :iso3 => 'LTU', :numcode => '440') 
    Country.create(:iso => 'LU', :name => 'LUXEMBOURG', :printable_name => 'Luxembourg', :iso3 => 'LUX', :numcode => '442') 
    Country.create(:iso => 'MO', :name => 'MACAO', :printable_name => 'Macao', :iso3 => 'MAC', :numcode => '446') 
    Country.create(:iso => 'MK', :name => 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', :printable_name => 'Macedonia, the Former Yugoslav Republic of', :iso3 => 'MKD', :numcode => '807') 
    Country.create(:iso => 'MG', :name => 'MADAGASCAR', :printable_name => 'Madagascar', :iso3 => 'MDG', :numcode => '450') 
    Country.create(:iso => 'MW', :name => 'MALAWI', :printable_name => 'Malawi', :iso3 => 'MWI', :numcode => '454') 
    Country.create(:iso => 'MY', :name => 'MALAYSIA', :printable_name => 'Malaysia', :iso3 => 'MYS', :numcode => '458') 
    Country.create(:iso => 'MV', :name => 'MALDIVES', :printable_name => 'Maldives', :iso3 => 'MDV', :numcode => '462') 
    Country.create(:iso => 'ML', :name => 'MALI', :printable_name => 'Mali', :iso3 => 'MLI', :numcode => '466') 
    Country.create(:iso => 'MT', :name => 'MALTA', :printable_name => 'Malta', :iso3 => 'MLT', :numcode => '470') 
    Country.create(:iso => 'MH', :name => 'MARSHALL ISLANDS', :printable_name => 'Marshall Islands', :iso3 => 'MHL', :numcode => '584') 
    Country.create(:iso => 'MQ', :name => 'MARTINIQUE', :printable_name => 'Martinique', :iso3 => 'MTQ', :numcode => '474') 
    Country.create(:iso => 'MR', :name => 'MAURITANIA', :printable_name => 'Mauritania', :iso3 => 'MRT', :numcode => '478') 
    Country.create(:iso => 'MU', :name => 'MAURITIUS', :printable_name => 'Mauritius', :iso3 => 'MUS', :numcode => '480') 
    Country.create(:iso => 'MX', :name => 'MEXICO', :printable_name => 'Mexico', :iso3 => 'MEX', :numcode => '484') 
    Country.create(:iso => 'FM', :name => 'MICRONESIA, FEDERATED STATES OF', :printable_name => 'Micronesia, Federated States of', :iso3 => 'FSM', :numcode => '583') 
    Country.create(:iso => 'MD', :name => 'MOLDOVA, REPUBLIC OF', :printable_name => 'Moldova, Republic of', :iso3 => 'MDA', :numcode => '498') 
    Country.create(:iso => 'MC', :name => 'MONACO', :printable_name => 'Monaco', :iso3 => 'MCO', :numcode => '492') 
    Country.create(:iso => 'MN', :name => 'MONGOLIA', :printable_name => 'Mongolia', :iso3 => 'MNG', :numcode => '496') 
    Country.create(:iso => 'MS', :name => 'MONTSERRAT', :printable_name => 'Montserrat', :iso3 => 'MSR', :numcode => '500') 
    Country.create(:iso => 'MA', :name => 'MOROCCO', :printable_name => 'Morocco', :iso3 => 'MAR', :numcode => '504') 
    Country.create(:iso => 'MZ', :name => 'MOZAMBIQUE', :printable_name => 'Mozambique', :iso3 => 'MOZ', :numcode => '508') 
    Country.create(:iso => 'MM', :name => 'MYANMAR', :printable_name => 'Myanmar', :iso3 => 'MMR', :numcode => '104') 
    Country.create(:iso => 'NA', :name => 'NAMIBIA', :printable_name => 'Namibia', :iso3 => 'NAM', :numcode => '516') 
    Country.create(:iso => 'NR', :name => 'NAURU', :printable_name => 'Nauru', :iso3 => 'NRU', :numcode => '520') 
    Country.create(:iso => 'NP', :name => 'NEPAL', :printable_name => 'Nepal', :iso3 => 'NPL', :numcode => '524') 
    Country.create(:iso => 'NL', :name => 'NETHERLANDS', :printable_name => 'Netherlands', :iso3 => 'NLD', :numcode => '528') 
    Country.create(:iso => 'AN', :name => 'NETHERLANDS ANTILLES', :printable_name => 'Netherlands Antilles', :iso3 => 'ANT', :numcode => '530') 
    Country.create(:iso => 'NC', :name => 'NEW CALEDONIA', :printable_name => 'New Caledonia', :iso3 => 'NCL', :numcode => '540') 
    Country.create(:iso => 'NZ', :name => 'NEW ZEALAND', :printable_name => 'New Zealand', :iso3 => 'NZL', :numcode => '554') 
    Country.create(:iso => 'NI', :name => 'NICARAGUA', :printable_name => 'Nicaragua', :iso3 => 'NIC', :numcode => '558') 
    Country.create(:iso => 'NE', :name => 'NIGER', :printable_name => 'Niger', :iso3 => 'NER', :numcode => '562') 
    Country.create(:iso => 'NG', :name => 'NIGERIA', :printable_name => 'Nigeria', :iso3 => 'NGA', :numcode => '566') 
    Country.create(:iso => 'NU', :name => 'NIUE', :printable_name => 'Niue', :iso3 => 'NIU', :numcode => '570') 
    Country.create(:iso => 'NF', :name => 'NORFOLK ISLAND', :printable_name => 'Norfolk Island', :iso3 => 'NFK', :numcode => '574') 
    Country.create(:iso => 'MP', :name => 'NORTHERN MARIANA ISLANDS', :printable_name => 'Northern Mariana Islands', :iso3 => 'MNP', :numcode => '580') 
    Country.create(:iso => 'NO', :name => 'NORWAY', :printable_name => 'Norway', :iso3 => 'NOR', :numcode => '578') 
    Country.create(:iso => 'OM', :name => 'OMAN', :printable_name => 'Oman', :iso3 => 'OMN', :numcode => '512') 
    Country.create(:iso => 'PK', :name => 'PAKISTAN', :printable_name => 'Pakistan', :iso3 => 'PAK', :numcode => '586') 
    Country.create(:iso => 'PW', :name => 'PALAU', :printable_name => 'Palau', :iso3 => 'PLW', :numcode => '585') 
    Country.create(:iso => 'PA', :name => 'PANAMA', :printable_name => 'Panama', :iso3 => 'PAN', :numcode => '591') 
    Country.create(:iso => 'PG', :name => 'PAPUA NEW GUINEA', :printable_name => 'Papua New Guinea', :iso3 => 'PNG', :numcode => '598') 
    Country.create(:iso => 'PY', :name => 'PARAGUAY', :printable_name => 'Paraguay', :iso3 => 'PRY', :numcode => '600') 
    Country.create(:iso => 'PE', :name => 'PERU', :printable_name => 'Peru', :iso3 => 'PER', :numcode => '604') 
    Country.create(:iso => 'PH', :name => 'PHILIPPINES', :printable_name => 'Philippines', :iso3 => 'PHL', :numcode => '608') 
    Country.create(:iso => 'PN', :name => 'PITCAIRN', :printable_name => 'Pitcairn', :iso3 => 'PCN', :numcode => '612') 
    Country.create(:iso => 'PL', :name => 'POLAND', :printable_name => 'Poland', :iso3 => 'POL', :numcode => '616') 
    Country.create(:iso => 'PT', :name => 'PORTUGAL', :printable_name => 'Portugal', :iso3 => 'PRT', :numcode => '620') 
    Country.create(:iso => 'PR', :name => 'PUERTO RICO', :printable_name => 'Puerto Rico', :iso3 => 'PRI', :numcode => '630') 
    Country.create(:iso => 'QA', :name => 'QATAR', :printable_name => 'Qatar', :iso3 => 'QAT', :numcode => '634') 
    Country.create(:iso => 'RE', :name => 'REUNION', :printable_name => 'Reunion', :iso3 => 'REU', :numcode => '638') 
    Country.create(:iso => 'RO', :name => 'ROMANIA', :printable_name => 'Romania', :iso3 => 'ROM', :numcode => '642') 
    Country.create(:iso => 'RU', :name => 'RUSSIAN FEDERATION', :printable_name => 'Russian Federation', :iso3 => 'RUS', :numcode => '643') 
    Country.create(:iso => 'RW', :name => 'RWANDA', :printable_name => 'Rwanda', :iso3 => 'RWA', :numcode => '646') 
    Country.create(:iso => 'SH', :name => 'SAINT HELENA', :printable_name => 'Saint Helena', :iso3 => 'SHN', :numcode => '654') 
    Country.create(:iso => 'KN', :name => 'SAINT KITTS AND NEVIS', :printable_name => 'Saint Kitts and Nevis', :iso3 => 'KNA', :numcode => '659') 
    Country.create(:iso => 'LC', :name => 'SAINT LUCIA', :printable_name => 'Saint Lucia', :iso3 => 'LCA', :numcode => '662') 
    Country.create(:iso => 'PM', :name => 'SAINT PIERRE AND MIQUELON', :printable_name => 'Saint Pierre and Miquelon', :iso3 => 'SPM', :numcode => '666') 
    Country.create(:iso => 'VC', :name => 'SAINT VINCENT AND THE GRENADINES', :printable_name => 'Saint Vincent and the Grenadines', :iso3 => 'VCT', :numcode => '670') 
    Country.create(:iso => 'WS', :name => 'SAMOA', :printable_name => 'Samoa', :iso3 => 'WSM', :numcode => '882') 
    Country.create(:iso => 'SM', :name => 'SAN MARINO', :printable_name => 'San Marino', :iso3 => 'SMR', :numcode => '674') 
    Country.create(:iso => 'ST', :name => 'SAO TOME AND PRINCIPE', :printable_name => 'Sao Tome and Principe', :iso3 => 'STP', :numcode => '678') 
    Country.create(:iso => 'SA', :name => 'SAUDI ARABIA', :printable_name => 'Saudi Arabia', :iso3 => 'SAU', :numcode => '682') 
    Country.create(:iso => 'SN', :name => 'SENEGAL', :printable_name => 'Senegal', :iso3 => 'SEN', :numcode => '686') 
    Country.create(:iso => 'SC', :name => 'SEYCHELLES', :printable_name => 'Seychelles', :iso3 => 'SYC', :numcode => '690') 
    Country.create(:iso => 'SL', :name => 'SIERRA LEONE', :printable_name => 'Sierra Leone', :iso3 => 'SLE', :numcode => '694') 
    Country.create(:iso => 'SG', :name => 'SINGAPORE', :printable_name => 'Singapore', :iso3 => 'SGP', :numcode => '702') 
    Country.create(:iso => 'SK', :name => 'SLOVAKIA', :printable_name => 'Slovakia', :iso3 => 'SVK', :numcode => '703') 
    Country.create(:iso => 'SI', :name => 'SLOVENIA', :printable_name => 'Slovenia', :iso3 => 'SVN', :numcode => '705') 
    Country.create(:iso => 'SB', :name => 'SOLOMON ISLANDS', :printable_name => 'Solomon Islands', :iso3 => 'SLB', :numcode => '090') 
    Country.create(:iso => 'SO', :name => 'SOMALIA', :printable_name => 'Somalia', :iso3 => 'SOM', :numcode => '706') 
    Country.create(:iso => 'ZA', :name => 'SOUTH AFRICA', :printable_name => 'South Africa', :iso3 => 'ZAF', :numcode => '710') 
    Country.create(:iso => 'ES', :name => 'SPAIN', :printable_name => 'Spain', :iso3 => 'ESP', :numcode => '724') 
    Country.create(:iso => 'LK', :name => 'SRI LANKA', :printable_name => 'Sri Lanka', :iso3 => 'LKA', :numcode => '144') 
    Country.create(:iso => 'SD', :name => 'SUDAN', :printable_name => 'Sudan', :iso3 => 'SDN', :numcode => '736') 
    Country.create(:iso => 'SR', :name => 'SURINAME', :printable_name => 'Suriname', :iso3 => 'SUR', :numcode => '740') 
    Country.create(:iso => 'SJ', :name => 'SVALBARD AND JAN MAYEN', :printable_name => 'Svalbard and Jan Mayen', :iso3 => 'SJM', :numcode => '744') 
    Country.create(:iso => 'SZ', :name => 'SWAZILAND', :printable_name => 'Swaziland', :iso3 => 'SWZ', :numcode => '748') 
    Country.create(:iso => 'SE', :name => 'SWEDEN', :printable_name => 'Sweden', :iso3 => 'SWE', :numcode => '752') 
    Country.create(:iso => 'CH', :name => 'SWITZERLAND', :printable_name => 'Switzerland', :iso3 => 'CHE', :numcode => '756') 
    Country.create(:iso => 'SY', :name => 'SYRIAN ARAB REPUBLIC', :printable_name => 'Syrian Arab Republic', :iso3 => 'SYR', :numcode => '760') 
    Country.create(:iso => 'TW', :name => 'TAIWAN, PROVINCE OF CHINA', :printable_name => 'Taiwan, Province of China', :iso3 => 'TWN', :numcode => '158') 
    Country.create(:iso => 'TJ', :name => 'TAJIKISTAN', :printable_name => 'Tajikistan', :iso3 => 'TJK', :numcode => '762') 
    Country.create(:iso => 'TZ', :name => 'TANZANIA, UNITED REPUBLIC OF', :printable_name => 'Tanzania, United Republic of', :iso3 => 'TZA', :numcode => '834') 
    Country.create(:iso => 'TH', :name => 'THAILAND', :printable_name => 'Thailand', :iso3 => 'THA', :numcode => '764') 
    Country.create(:iso => 'TG', :name => 'TOGO', :printable_name => 'Togo', :iso3 => 'TGO', :numcode => '768') 
    Country.create(:iso => 'TK', :name => 'TOKELAU', :printable_name => 'Tokelau', :iso3 => 'TKL', :numcode => '772') 
    Country.create(:iso => 'TO', :name => 'TONGA', :printable_name => 'Tonga', :iso3 => 'TON', :numcode => '776') 
    Country.create(:iso => 'TT', :name => 'TRINIDAD AND TOBAGO', :printable_name => 'Trinidad and Tobago', :iso3 => 'TTO', :numcode => '780') 
    Country.create(:iso => 'TN', :name => 'TUNISIA', :printable_name => 'Tunisia', :iso3 => 'TUN', :numcode => '788') 
    Country.create(:iso => 'TR', :name => 'TURKEY', :printable_name => 'Turkey', :iso3 => 'TUR', :numcode => '792') 
    Country.create(:iso => 'TM', :name => 'TURKMENISTAN', :printable_name => 'Turkmenistan', :iso3 => 'TKM', :numcode => '795') 
    Country.create(:iso => 'TC', :name => 'TURKS AND CAICOS ISLANDS', :printable_name => 'Turks and Caicos Islands', :iso3 => 'TCA', :numcode => '796') 
    Country.create(:iso => 'TV', :name => 'TUVALU', :printable_name => 'Tuvalu', :iso3 => 'TUV', :numcode => '798') 
    Country.create(:iso => 'UG', :name => 'UGANDA', :printable_name => 'Uganda', :iso3 => 'UGA', :numcode => '800') 
    Country.create(:iso => 'UA', :name => 'UKRAINE', :printable_name => 'Ukraine', :iso3 => 'UKR', :numcode => '804') 
    Country.create(:iso => 'AE', :name => 'UNITED ARAB EMIRATES', :printable_name => 'United Arab Emirates', :iso3 => 'ARE', :numcode => '784') 
    Country.create(:iso => 'GB', :name => 'UNITED KINGDOM', :printable_name => 'United Kingdom', :iso3 => 'GBR', :numcode => '826') 
    Country.create(:iso => 'US', :name => 'UNITED STATES', :printable_name => 'United States', :iso3 => 'USA', :numcode => '840') 
    Country.create(:iso => 'UY', :name => 'URUGUAY', :printable_name => 'Uruguay', :iso3 => 'URY', :numcode => '858') 
    Country.create(:iso => 'UZ', :name => 'UZBEKISTAN', :printable_name => 'Uzbekistan', :iso3 => 'UZB', :numcode => '860') 
    Country.create(:iso => 'VU', :name => 'VANUATU', :printable_name => 'Vanuatu', :iso3 => 'VUT', :numcode => '548') 
    Country.create(:iso => 'VE', :name => 'VENEZUELA', :printable_name => 'Venezuela', :iso3 => 'VEN', :numcode => '862') 
    Country.create(:iso => 'VN', :name => 'VIET NAM', :printable_name => 'Viet Nam', :iso3 => 'VNM', :numcode => '704') 
    Country.create(:iso => 'VG', :name => 'VIRGIN ISLANDS, BRITISH', :printable_name => 'Virgin Islands, British', :iso3 => 'VGB', :numcode => '092') 
    Country.create(:iso => 'VI', :name => 'VIRGIN ISLANDS, U.S.', :printable_name => 'Virgin Islands, U.s.', :iso3 => 'VIR', :numcode => '850') 
    Country.create(:iso => 'WF', :name => 'WALLIS AND FUTUNA', :printable_name => 'Wallis and Futuna', :iso3 => 'WLF', :numcode => '876') 
    Country.create(:iso => 'EH', :name => 'WESTERN SAHARA', :printable_name => 'Western Sahara', :iso3 => 'ESH', :numcode => '732') 
    Country.create(:iso => 'YE', :name => 'YEMEN', :printable_name => 'Yemen', :iso3 => 'YEM', :numcode => '887') 
    Country.create(:iso => 'ZM', :name => 'ZAMBIA', :printable_name => 'Zambia', :iso3 => 'ZMB', :numcode => '894') 
    Country.create(:iso => 'ZW', :name => 'ZIMBABWE', :printable_name => 'Zimbabwe', :iso3 => 'ZWE', :numcode => '716') 

  end

  def self.down
    drop_table :countries
  end

end
