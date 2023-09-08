FantasyDrop - додаток для перегляду файлів у Dropbox. У якості архітектури було обрано MVVM+C. Ця архітектура дозволяє писати код модульно. Переваги архітектури - можна запустити кожен компонент програми з будь-якого місця, витративши мінімум часу, а також можливість швидко і зручно доповнювати програму новим функціоналом. Також переслідується рішення відмови від універсальності коду і у тих місцях де могло б бути наслідування, вирішено писати код під потреби модуля.
У проекті відсутні storyboards, весь UI виконано кодом з використанням SnapKit. У кожен координатор та viewModel(у якій потрібно виконувати мережеві запити) передається клас Api, який можна ініціалізувати з accessToken і refreshToken. Це вигідне рішення для тестування Виходячи з потреб додатку, стандартна авторизація Dropbox відсутня (але у програмі є AuthCoordinator де прописана вся логіка dropbox auth flow), тому обрано рішення отримувати access token завдяки вшитому у програму refresh token (весь процес відбувається у LoadingCoordinator)
Кешування мініатюр файлів - у сінглтоні ThumbnailManager. Повнорозмірні файли зберігаються у FileManager - при бажанні можна доповнити код і видаляти їх перед тим як програма піде з пам’яті. 
Програму можна легко розширювати і доповнювати новим функціоналом

