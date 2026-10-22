# Build steps for the Sim2Real Blogs image, run by brev/dockerfile after the
# hash lock in requirements.txt is installed.

pip freeze > /tmp/locked-constraints.txt
pip install -c /tmp/locked-constraints.txt -r notebook-requirements.txt
pip check
rm -f /tmp/locked-constraints.txt
