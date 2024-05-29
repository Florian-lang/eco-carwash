echo "Installing api"
cd ../
git clone https://github.com/Florian-lang/eco-carwash-api.git
# shellcheck disable=SC2164
cd eco-carwash-api
bash init.sh

echo "Installing dependencies"
# shellcheck disable=SC2164
cd ../eco-carwash
flutter pub get
echo "Done"
